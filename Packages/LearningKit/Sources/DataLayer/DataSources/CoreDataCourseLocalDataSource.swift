import Core
import CoreData
import Domain
import Persistence

public struct CoreDataCourseLocalDataSource: CourseLocalDataSource {
    private let stack: CoreDataStack

    public init(stack: CoreDataStack) {
        self.stack = stack
    }

    public func courses() async throws -> [Course] {
        try await stack.perform { context in
            let request = CourseRecord.request()
            request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
            return try context.fetch(request).map(\.domainCourse)
        }
    }

    public func replaceCourses(with courses: [Course]) async throws {
        try await stack.perform { context in
            let existing = try Self.courseRecordsByID(in: context)
            let incomingIDs = Set(courses.map { Int64($0.id) })
            for (id, record) in existing where !incomingIDs.contains(id) {
                context.delete(record)
            }
            for (index, course) in courses.enumerated() {
                let record = existing[Int64(course.id)] ?? CourseRecord(context: context)
                record.merge(course)
                record.position = Int32(index)
            }
        }
    }

    public func courseDetail(id: Course.ID) async throws -> CourseDetail? {
        try await stack.perform { context in
            guard let record = try Self.courseRecord(id: id, in: context), !record.lessons.isEmpty else {
                return nil
            }
            return record.domainDetail
        }
    }

    public func saveCourseDetail(_ detail: CourseDetail) async throws {
        try await stack.perform { context in
            let record: CourseRecord
            if let existing = try Self.courseRecord(id: detail.course.id, in: context) {
                record = existing
            } else {
                record = CourseRecord(context: context)
                record.position = Int32.max
            }
            record.merge(detail.course)

            let existingLessons = Dictionary(uniqueKeysWithValues: record.lessons.map { ($0.id, $0) })
            let incomingIDs = Set(detail.lessons.map { Int64($0.id) })
            for (id, lesson) in existingLessons where !incomingIDs.contains(id) {
                context.delete(lesson)
            }
            for (index, lesson) in detail.lessons.enumerated() {
                let lessonRecord = existingLessons[Int64(lesson.id)] ?? LessonRecord(context: context)
                lessonRecord.merge(lesson, position: index)
                lessonRecord.course = record
            }
        }
    }

    public func markLessonCompleted(lessonID: Lesson.ID, courseID: Course.ID, courseProgress: Int) async throws {
        try await stack.perform { context in
            let request = LessonRecord.request()
            request.predicate = NSPredicate(format: "id == %lld AND course.id == %lld", Int64(lessonID), Int64(courseID))
            request.fetchLimit = 1
            guard let lesson = try context.fetch(request).first, let course = lesson.course else {
                throw AppError.notFound
            }
            lesson.isCompleted = true
            lesson.needsSync = true
            course.progress = Int16(courseProgress)
        }
    }

    public func pendingLessonCompletions() async throws -> [PendingLessonCompletion] {
        try await stack.perform { context in
            let request = LessonRecord.request()
            request.predicate = NSPredicate(format: "needsSync == YES")
            return try context.fetch(request).compactMap { lesson in
                guard let course = lesson.course else { return nil }
                return PendingLessonCompletion(courseID: Int(course.id), lessonID: Int(lesson.id))
            }
        }
    }

    public func markLessonSynced(lessonID: Lesson.ID) async throws {
        try await stack.perform { context in
            let request = LessonRecord.request()
            request.predicate = NSPredicate(format: "id == %lld", Int64(lessonID))
            try context.fetch(request).forEach { $0.needsSync = false }
        }
    }

    public func removeAll() async throws {
        try await stack.perform { context in
            try context.fetch(CourseRecord.request()).forEach(context.delete)
        }
    }

    private static func courseRecordsByID(in context: NSManagedObjectContext) throws -> [Int64: CourseRecord] {
        let records = try context.fetch(CourseRecord.request())
        return Dictionary(records.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
    }

    private static func courseRecord(id: Course.ID, in context: NSManagedObjectContext) throws -> CourseRecord? {
        let request = CourseRecord.request()
        request.predicate = NSPredicate(format: "id == %lld", Int64(id))
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}

private extension CourseRecord {
    var domainCourse: Course {
        Course(
            id: Int(id),
            title: title,
            instructor: instructor,
            progress: Int(progress),
            lessonCount: Int(lessonCount)
        )
    }

    var domainDetail: CourseDetail {
        let orderedLessons = lessons.sorted { $0.position < $1.position }
        return CourseDetail(course: domainCourse, lessons: orderedLessons.map(\.domainLesson))
    }

    func merge(_ course: Course) {
        id = Int64(course.id)
        title = course.title
        instructor = course.instructor
        lessonCount = Int16(course.lessonCount)
        progress = Int16(max(Int(progress), course.progress))
    }
}

private extension LessonRecord {
    var domainLesson: Lesson {
        Lesson(id: Int(id), title: title, isCompleted: isCompleted)
    }

    func merge(_ lesson: Lesson, position index: Int) {
        id = Int64(lesson.id)
        title = lesson.title
        position = Int32(index)
        isCompleted = isCompleted || lesson.isCompleted
    }
}
