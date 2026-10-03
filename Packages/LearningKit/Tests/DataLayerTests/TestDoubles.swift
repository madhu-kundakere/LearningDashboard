import DataLayer
import Foundation
import Networking

actor StubCourseRemoteDataSource: CourseRemoteDataSource {
    var coursesResult: Result<[CourseSummaryDTO], NetworkError>
    var detailResult: Result<CourseDetailDTO, NetworkError>
    var completionError: NetworkError?
    private(set) var syncedLessonIDs: [Int] = []

    init(
        courses: Result<[CourseSummaryDTO], NetworkError> = .success([]),
        detail: Result<CourseDetailDTO, NetworkError> = .failure(.notFound)
    ) {
        coursesResult = courses
        detailResult = detail
    }

    func setCourses(_ result: Result<[CourseSummaryDTO], NetworkError>) {
        coursesResult = result
    }

    func setDetail(_ result: Result<CourseDetailDTO, NetworkError>) {
        detailResult = result
    }

    func setCompletionError(_ error: NetworkError?) {
        completionError = error
    }

    func fetchCourses() async throws -> [CourseSummaryDTO] {
        try coursesResult.get()
    }

    func fetchCourseDetail(id: Int) async throws -> CourseDetailDTO {
        try detailResult.get()
    }

    func markLessonCompleted(courseID: Int, lessonID: Int) async throws {
        if let completionError { throw completionError }
        syncedLessonIDs.append(lessonID)
    }
}

struct StubHTTPClient: HTTPClient {
    let result: @Sendable (Endpoint) throws -> Data

    func send(_ endpoint: Endpoint) async throws -> Data {
        try result(endpoint)
    }
}

enum Fixtures {
    static let courses = [
        CourseSummaryDTO(id: 1, title: "Python Programming", instructor: "John Smith", progress: 65, lessons: 20),
        CourseSummaryDTO(id: 2, title: "Generative AI", instructor: "Sarah Williams", progress: 40, lessons: 16),
        CourseSummaryDTO(id: 3, title: "Full Stack Development", instructor: "David Brown", progress: 25, lessons: 28),
    ]

    static let pythonDetail = CourseDetailDTO(
        id: 1,
        title: "Python Programming",
        instructor: "John Smith",
        progress: 50,
        lessons: [
            LessonDTO(id: 101, title: "Introduction", completed: true),
            LessonDTO(id: 102, title: "Variables & Data Types", completed: true),
            LessonDTO(id: 103, title: "Functions", completed: false),
            LessonDTO(id: 104, title: "OOP", completed: false),
        ]
    )
}
