public protocol CourseRepository: Sendable {
    func cachedCourses() async throws -> [Course]
    func refreshCourses() async throws -> [Course]
    func cachedCourseDetail(id: Course.ID) async throws -> CourseDetail?
    func refreshCourseDetail(id: Course.ID) async throws -> CourseDetail
    func markLessonCompleted(lessonID: Lesson.ID, courseID: Course.ID, courseProgress: Int) async throws
    func clearCache() async throws
}
