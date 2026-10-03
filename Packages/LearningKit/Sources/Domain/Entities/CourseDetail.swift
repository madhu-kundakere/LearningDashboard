public struct CourseDetail: Equatable, Sendable {
    public let course: Course
    public let lessons: [Lesson]

    public init(course: Course, lessons: [Lesson]) {
        self.course = course
        self.lessons = lessons
    }

    public var completedLessonCount: Int {
        lessons.count(where: \.isCompleted)
    }
}
