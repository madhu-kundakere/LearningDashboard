import Domain

public struct PendingLessonCompletion: Equatable, Sendable {
    public let courseID: Course.ID
    public let lessonID: Lesson.ID
}

public protocol CourseLocalDataSource: Sendable {
    func courses() async throws -> [Course]
    func replaceCourses(with courses: [Course]) async throws
    func courseDetail(id: Course.ID) async throws -> CourseDetail?
    func saveCourseDetail(_ detail: CourseDetail) async throws
    func markLessonCompleted(lessonID: Lesson.ID, courseID: Course.ID, courseProgress: Int) async throws
    func pendingLessonCompletions() async throws -> [PendingLessonCompletion]
    func markLessonSynced(lessonID: Lesson.ID) async throws
    func removeAll() async throws
}
