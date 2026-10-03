import Core
import CoursesFeature
import Domain
import Testing

@MainActor
struct CourseListViewModelTests {
    @Test func successfulRefreshShowsCourses() async {
        let viewModel = CourseListViewModel(fetchCourses: FetchCoursesStub(cached: [], refreshed: .success(Self.courses)))

        await viewModel.onAppear()

        #expect(viewModel.state == .loaded(Self.courses))
        #expect(viewModel.refreshError == nil)
    }

    @Test func emptyResponseShowsEmptyState() async {
        let viewModel = CourseListViewModel(fetchCourses: FetchCoursesStub(cached: [], refreshed: .success([])))

        await viewModel.onAppear()

        #expect(viewModel.state == .empty)
    }

    @Test func failureWithoutCacheShowsErrorState() async {
        let viewModel = CourseListViewModel(fetchCourses: FetchCoursesStub(cached: [], refreshed: .failure(.server(statusCode: 500))))

        await viewModel.onAppear()

        #expect(viewModel.state == .failed(.server(statusCode: 500)))
    }

    @Test func offlineWithCacheKeepsCoursesAndFlagsOffline() async {
        let viewModel = CourseListViewModel(fetchCourses: FetchCoursesStub(cached: Self.courses, refreshed: .failure(.offline)))

        await viewModel.onAppear()

        #expect(viewModel.state == .loaded(Self.courses))
        #expect(viewModel.refreshError == .offline)
    }

    private static let courses = [
        Course(id: 1, title: "Python Programming", instructor: "John Smith", progress: 65, lessonCount: 20),
        Course(id: 2, title: "Generative AI", instructor: "Sarah Williams", progress: 40, lessonCount: 16),
    ]
}

private struct FetchCoursesStub: FetchCoursesUseCase {
    let cached: [Course]
    let refreshed: Result<[Course], AppError>

    func cached() async throws -> [Course] { cached }
    func refreshed() async throws -> [Course] { try refreshed.get() }
}
