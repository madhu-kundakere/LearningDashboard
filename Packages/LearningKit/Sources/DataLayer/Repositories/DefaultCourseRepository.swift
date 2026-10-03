import Core
import Domain
import os

public struct DefaultCourseRepository: CourseRepository {
    private let remote: any CourseRemoteDataSource
    private let local: any CourseLocalDataSource
    private let logger = Logger(subsystem: "LearningKit", category: "CourseRepository")

    public init(remote: any CourseRemoteDataSource, local: any CourseLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    public func cachedCourses() async throws -> [Course] {
        try await mappingErrors { try await local.courses() }
    }

    public func refreshCourses() async throws -> [Course] {
        try await mappingErrors {
            await syncPendingCompletions()
            let courses = try await remote.fetchCourses().map { $0.toDomain() }
            try await local.replaceCourses(with: courses)
            return try await local.courses()
        }
    }

    public func cachedCourseDetail(id: Course.ID) async throws -> CourseDetail? {
        try await mappingErrors { try await local.courseDetail(id: id) }
    }

    public func refreshCourseDetail(id: Course.ID) async throws -> CourseDetail {
        try await mappingErrors {
            let detail = try await remote.fetchCourseDetail(id: id).toDomain()
            try await local.saveCourseDetail(detail)
            return try await local.courseDetail(id: id) ?? detail
        }
    }

    public func markLessonCompleted(lessonID: Lesson.ID, courseID: Course.ID, courseProgress: Int) async throws {
        try await mappingErrors {
            try await local.markLessonCompleted(lessonID: lessonID, courseID: courseID, courseProgress: courseProgress)
        }
        Task { await syncPendingCompletions() }
    }

    public func clearCache() async throws {
        try await mappingErrors { try await local.removeAll() }
    }

    func syncPendingCompletions() async {
        guard let pending = try? await local.pendingLessonCompletions() else { return }
        for completion in pending {
            do {
                try await remote.markLessonCompleted(courseID: completion.courseID, lessonID: completion.lessonID)
                try await local.markLessonSynced(lessonID: completion.lessonID)
            } catch {
                logger.info("Lesson sync deferred: \(error.localizedDescription)")
                return
            }
        }
    }

    private func mappingErrors<Value>(_ work: () async throws -> Value) async throws -> Value {
        do {
            return try await work()
        } catch {
            throw AppError(mapping: error)
        }
    }
}
