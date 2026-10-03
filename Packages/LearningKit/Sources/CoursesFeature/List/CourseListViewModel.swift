import Core
import Domain
import Observation

@MainActor
@Observable
public final class CourseListViewModel {
    public private(set) var state: ViewState<[Course]> = .idle
    public private(set) var refreshError: AppError?
    public private(set) var isRefreshing = false

    private let fetchCourses: any FetchCoursesUseCase
    private var hasLoaded = false

    public init(fetchCourses: any FetchCoursesUseCase) {
        self.fetchCourses = fetchCourses
    }

    public func onAppear() async {
        if hasLoaded {
            await reloadFromCache()
        } else {
            hasLoaded = true
            await load()
        }
    }

    public func load() async {
        let cached = (try? await fetchCourses.cached()) ?? []
        state = cached.isEmpty ? .loading : .loaded(cached)
        await refresh()
    }

    public func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        do {
            let courses = try await fetchCourses.refreshed()
            refreshError = nil
            state = courses.isEmpty ? .empty : .loaded(courses)
        } catch {
            handleRefreshFailure(AppError(error))
        }
    }

    private func reloadFromCache() async {
        guard let courses = try? await fetchCourses.cached(), !courses.isEmpty else { return }
        state = .loaded(courses)
    }

    private func handleRefreshFailure(_ error: AppError) {
        if case .loaded = state {
            refreshError = error
        } else {
            refreshError = nil
            state = .failed(error)
        }
    }
}
