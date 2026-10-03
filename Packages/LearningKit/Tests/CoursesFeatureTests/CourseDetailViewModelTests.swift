import Core
import CoursesFeature
import Domain
import Testing

@MainActor
struct CourseDetailViewModelTests {
    @Test func completingLessonUpdatesDisplayedProgress() async {
        let viewModel = CourseDetailViewModel(
            course: Self.detail.course,
            getCourseDetail: GetCourseDetailStub(detail: Self.detail),
            completeLesson: DefaultCompleteLessonUseCase(repository: NoOpCourseRepository())
        )
        await viewModel.load()

        await viewModel.completeLesson(3)

        let detail = viewModel.state.value
        #expect(detail?.course.progress == 75)
        #expect(detail?.lessons.first { $0.id == 3 }?.isCompleted == true)
        #expect(viewModel.completingLessonIDs.isEmpty)
    }

    private static let detail = CourseDetail(
        course: Course(id: 1, title: "Python Programming", instructor: "John Smith", progress: 50, lessonCount: 4),
        lessons: [
            Lesson(id: 1, title: "Introduction", isCompleted: true),
            Lesson(id: 2, title: "Variables & Data Types", isCompleted: true),
            Lesson(id: 3, title: "Functions", isCompleted: false),
            Lesson(id: 4, title: "OOP", isCompleted: false),
        ]
    )
}

private struct GetCourseDetailStub: GetCourseDetailUseCase {
    let detail: CourseDetail

    func cached(courseID: Course.ID) async throws -> CourseDetail? { nil }
    func refreshed(courseID: Course.ID) async throws -> CourseDetail { detail }
}

private struct NoOpCourseRepository: CourseRepository {
    func cachedCourses() async throws -> [Course] { [] }
    func refreshCourses() async throws -> [Course] { [] }
    func cachedCourseDetail(id: Course.ID) async throws -> CourseDetail? { nil }
    func refreshCourseDetail(id: Course.ID) async throws -> CourseDetail { throw AppError.notFound }
    func markLessonCompleted(lessonID: Lesson.ID, courseID: Course.ID, courseProgress: Int) async throws {}
    func clearCache() async throws {}
}
