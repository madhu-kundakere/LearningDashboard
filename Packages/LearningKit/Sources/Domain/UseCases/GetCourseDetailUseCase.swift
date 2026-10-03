public protocol GetCourseDetailUseCase: Sendable {
    func cached(courseID: Course.ID) async throws -> CourseDetail?
    func refreshed(courseID: Course.ID) async throws -> CourseDetail
}

public struct DefaultGetCourseDetailUseCase: GetCourseDetailUseCase {
    private let repository: any CourseRepository

    public init(repository: any CourseRepository) {
        self.repository = repository
    }

    public func cached(courseID: Course.ID) async throws -> CourseDetail? {
        try await repository.cachedCourseDetail(id: courseID)
    }

    public func refreshed(courseID: Course.ID) async throws -> CourseDetail {
        try await repository.refreshCourseDetail(id: courseID)
    }
}
