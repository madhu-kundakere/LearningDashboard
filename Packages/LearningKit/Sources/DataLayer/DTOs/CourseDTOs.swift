import Domain

public struct CourseSummaryDTO: Codable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let instructor: String
    public let progress: Int
    public let lessons: Int

    public init(id: Int, title: String, instructor: String, progress: Int, lessons: Int) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessons = lessons
    }

    func toDomain() -> Course {
        Course(id: id, title: title, instructor: instructor, progress: progress, lessonCount: lessons)
    }
}

public struct LessonDTO: Codable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let completed: Bool

    public init(id: Int, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }

    func toDomain() -> Lesson {
        Lesson(id: id, title: title, isCompleted: completed)
    }
}

public struct CourseDetailDTO: Codable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let instructor: String
    public let progress: Int
    public let lessons: [LessonDTO]

    public init(id: Int, title: String, instructor: String, progress: Int, lessons: [LessonDTO]) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessons = lessons
    }

    func toDomain() -> CourseDetail {
        CourseDetail(
            course: Course(id: id, title: title, instructor: instructor, progress: progress, lessonCount: lessons.count),
            lessons: lessons.map { $0.toDomain() }
        )
    }
}
