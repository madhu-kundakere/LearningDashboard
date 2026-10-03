import Core
import Domain
import Observation

@MainActor
@Observable
public final class CourseDetailViewModel {
    public let course: Course
    public private(set) var state: ViewState<CourseDetail> = .idle
    public private(set) var refreshError: AppError?
    public private(set) var completingLessonIDs: Set<Lesson.ID> = []
    public var actionErrorMessage: String?

    private let getCourseDetail: any GetCourseDetailUseCase
    private let completeLesson: any CompleteLessonUseCase

    public init(
        course: Course,
        getCourseDetail: any GetCourseDetailUseCase,
        completeLesson: any CompleteLessonUseCase
    ) {
        self.course = course
        self.getCourseDetail = getCourseDetail
        self.completeLesson = completeLesson
    }

    public func load() async {
        if let cached = try? await getCourseDetail.cached(courseID: course.id) {
            state = .loaded(cached)
        } else {
            state = .loading
        }

        do {
            let detail = try await getCourseDetail.refreshed(courseID: course.id)
            refreshError = nil
            state = detail.lessons.isEmpty ? .empty : .loaded(detail)
        } catch {
            handleRefreshFailure(AppError(error))
        }
    }

    public func completeLesson(_ lessonID: Lesson.ID) async {
        guard case .loaded(let detail) = state, !completingLessonIDs.contains(lessonID) else { return }
        completingLessonIDs.insert(lessonID)
        defer { completingLessonIDs.remove(lessonID) }

        do {
            state = .loaded(try await completeLesson.execute(lessonID: lessonID, in: detail))
        } catch {
            actionErrorMessage = AppError(error).localizedDescription
        }
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
