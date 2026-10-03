import Core
import Domain
import Testing

struct CompleteLessonUseCaseTests {
    @Test func completingLessonUpdatesStatusAndRecalculatesProgress() async throws {
        let repository = CourseRepositorySpy()
        let useCase = DefaultCompleteLessonUseCase(repository: repository)
        let detail = makeDetail(completed: 13, total: 20)

        let updated = try await useCase.execute(lessonID: 14, in: detail)

        #expect(updated.lessons.first { $0.id == 14 }?.isCompleted == true)
        #expect(updated.completedLessonCount == 14)
        #expect(updated.course.progress == 70)
        #expect(await repository.completions == [.init(lessonID: 14, courseID: 1, courseProgress: 70)])
    }

    @Test func completingAlreadyCompletedLessonIsNoOp() async throws {
        let repository = CourseRepositorySpy()
        let useCase = DefaultCompleteLessonUseCase(repository: repository)
        let detail = makeDetail(completed: 13, total: 20)

        let updated = try await useCase.execute(lessonID: 1, in: detail)

        #expect(updated == detail)
        #expect(await repository.completions.isEmpty)
    }

    @Test func completingUnknownLessonThrowsNotFound() async {
        let useCase = DefaultCompleteLessonUseCase(repository: CourseRepositorySpy())

        await #expect(throws: AppError.notFound) {
            try await useCase.execute(lessonID: 999, in: makeDetail(completed: 0, total: 3))
        }
    }

    private func makeDetail(completed: Int, total: Int) -> CourseDetail {
        let lessons = (1...total).map { Lesson(id: $0, title: "Lesson \($0)", isCompleted: $0 <= completed) }
        let course = Course(
            id: 1,
            title: "Python Programming",
            instructor: "John Smith",
            progress: ProgressCalculator.percentage(completed: completed, total: total),
            lessonCount: total
        )
        return CourseDetail(course: course, lessons: lessons)
    }
}

private actor CourseRepositorySpy: CourseRepository {
    struct Completion: Equatable {
        let lessonID: Int
        let courseID: Int
        let courseProgress: Int
    }

    private(set) var completions: [Completion] = []

    func cachedCourses() async throws -> [Course] { [] }
    func refreshCourses() async throws -> [Course] { [] }
    func cachedCourseDetail(id: Course.ID) async throws -> CourseDetail? { nil }
    func refreshCourseDetail(id: Course.ID) async throws -> CourseDetail { throw AppError.notFound }
    func clearCache() async throws {}

    func markLessonCompleted(lessonID: Lesson.ID, courseID: Course.ID, courseProgress: Int) async throws {
        completions.append(Completion(lessonID: lessonID, courseID: courseID, courseProgress: courseProgress))
    }
}
