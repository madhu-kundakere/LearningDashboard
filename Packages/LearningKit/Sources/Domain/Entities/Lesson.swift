public struct Lesson: Identifiable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let isCompleted: Bool

    public init(id: Int, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }

    public func markedCompleted() -> Lesson {
        Lesson(id: id, title: title, isCompleted: true)
    }
}
