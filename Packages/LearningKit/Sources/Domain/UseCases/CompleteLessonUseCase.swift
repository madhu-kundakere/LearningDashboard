import Core

public protocol CompleteLessonUseCase: Sendable {
    func execute(lessonID: Lesson.ID, in detail: CourseDetail) async throws -> CourseDetail
}

public struct DefaultCompleteLessonUseCase: CompleteLessonUseCase {
    private let repository: any CourseRepository

    public init(repository: any CourseRepository) {
        self.repository = repository
    }

    public func execute(lessonID: Lesson.ID, in detail: CourseDetail) async throws -> CourseDetail {
        guard let lesson = detail.lessons.first(where: { $0.id == lessonID }) else {
            throw AppError.notFound
        }
        guard !lesson.isCompleted else { return detail }

        let lessons = detail.lessons.map { $0.id == lessonID ? $0.markedCompleted() : $0 }
        let progress = ProgressCalculator.percentage(
            completed: lessons.count(where: \.isCompleted),
            total: lessons.count
        )
        try await repository.markLessonCompleted(
            lessonID: lessonID,
            courseID: detail.course.id,
            courseProgress: progress
        )
        return CourseDetail(course: detail.course.withProgress(progress), lessons: lessons)
    }
}
