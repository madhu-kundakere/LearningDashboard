public struct Course: Identifiable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let instructor: String
    public let progress: Int
    public let lessonCount: Int

    public init(id: Int, title: String, instructor: String, progress: Int, lessonCount: Int) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessonCount = lessonCount
    }

    public func withProgress(_ progress: Int) -> Course {
        Course(id: id, title: title, instructor: instructor, progress: progress, lessonCount: lessonCount)
    }
}
