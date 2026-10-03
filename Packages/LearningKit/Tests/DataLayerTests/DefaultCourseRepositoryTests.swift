import Core
import DataLayer
import Domain
import Foundation
import Persistence
import Testing

struct DefaultCourseRepositoryTests {
    private let remote = StubCourseRemoteDataSource(courses: .success(Fixtures.courses))
    private let repository: DefaultCourseRepository

    init() throws {
        let stack = try CoreDataStack(kind: .inMemory, name: "Test-\(UUID().uuidString)")
        repository = DefaultCourseRepository(remote: remote, local: CoreDataCourseLocalDataSource(stack: stack))
    }

    @Test func previouslyLoadedCoursesRemainAvailableWhenOffline() async throws {
        let online = try await repository.refreshCourses()
        await remote.setCourses(.failure(.offline))

        await #expect(throws: AppError.offline) {
            try await repository.refreshCourses()
        }
        let offline = try await repository.cachedCourses()

        #expect(online.map(\.title) == ["Python Programming", "Generative AI", "Full Stack Development"])
        #expect(offline == online)
    }

    @Test func lessonCompletedOfflineSurvivesStaleServerRefresh() async throws {
        await remote.setDetail(.success(Fixtures.pythonDetail))
        await remote.setCompletionError(.offline)
        _ = try await repository.refreshCourseDetail(id: 1)

        try await repository.markLessonCompleted(lessonID: 103, courseID: 1, courseProgress: 75)
        let refreshed = try await repository.refreshCourseDetail(id: 1)

        #expect(refreshed.course.progress == 75)
        #expect(refreshed.lessons.map(\.isCompleted) == [true, true, true, false])
    }

    @Test func pendingCompletionIsSyncedOnNextRefreshOnceOnline() async throws {
        await remote.setDetail(.success(Fixtures.pythonDetail))
        await remote.setCompletionError(.offline)
        _ = try await repository.refreshCourseDetail(id: 1)
        try await repository.markLessonCompleted(lessonID: 103, courseID: 1, courseProgress: 75)

        await remote.setCompletionError(nil)
        _ = try await repository.refreshCourses()

        #expect(await remote.syncedLessonIDs.contains(103))
    }

    @Test func clearCacheRemovesAllCourses() async throws {
        _ = try await repository.refreshCourses()

        try await repository.clearCache()

        #expect(try await repository.cachedCourses().isEmpty)
    }
}
