import Foundation
import Networking

public protocol CourseRemoteDataSource: Sendable {
    func fetchCourses() async throws -> [CourseSummaryDTO]
    func fetchCourseDetail(id: Int) async throws -> CourseDetailDTO
    func markLessonCompleted(courseID: Int, lessonID: Int) async throws
}

public struct APICourseRemoteDataSource: CourseRemoteDataSource {
    private let client: any HTTPClient

    public init(client: any HTTPClient) {
        self.client = client
    }

    public func fetchCourses() async throws -> [CourseSummaryDTO] {
        try await client.send(Endpoint(path: "courses"), decoding: [CourseSummaryDTO].self)
    }

    public func fetchCourseDetail(id: Int) async throws -> CourseDetailDTO {
        try await client.send(Endpoint(path: "courses/\(id)"), decoding: CourseDetailDTO.self)
    }

    public func markLessonCompleted(courseID: Int, lessonID: Int) async throws {
        _ = try await client.send(
            Endpoint(path: "courses/\(courseID)/lessons/\(lessonID)/complete", method: .post)
        )
    }
}
