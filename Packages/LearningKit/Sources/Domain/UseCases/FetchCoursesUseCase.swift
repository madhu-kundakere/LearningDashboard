public protocol FetchCoursesUseCase: Sendable {
    func cached() async throws -> [Course]
    func refreshed() async throws -> [Course]
}

public struct DefaultFetchCoursesUseCase: FetchCoursesUseCase {
    private let repository: any CourseRepository

    public init(repository: any CourseRepository) {
        self.repository = repository
    }

    public func cached() async throws -> [Course] {
        try await repository.cachedCourses()
    }

    public func refreshed() async throws -> [Course] {
        try await repository.refreshCourses()
    }
}
