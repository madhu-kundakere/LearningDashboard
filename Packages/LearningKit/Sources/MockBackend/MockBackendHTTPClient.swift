import Core
import Foundation
import Networking

public struct MockBackendHTTPClient: HTTPClient {
    public static let demoPassword = "password123"

    private let reachability: any ReachabilityMonitoring
    private let scenario: MockScenario
    private let latency: Duration

    public init(
        reachability: any ReachabilityMonitoring,
        scenario: MockScenario = .normal,
        latency: Duration = .milliseconds(700)
    ) {
        self.reachability = reachability
        self.scenario = scenario
        self.latency = latency
    }

    public func send(_ endpoint: Endpoint) async throws -> Data {
        try await Task.sleep(for: latency)
        guard reachability.isConnected else { throw NetworkError.offline }

        let components = endpoint.path.split(separator: "/").map(String.init)
        switch (endpoint.method, components.count) {
        case (.post, 2) where components == ["auth", "login"]:
            return try login(body: endpoint.body)
        case (.get, 1) where components[0] == "courses":
            return try courses()
        case (.get, 2) where components[0] == "courses":
            return try fixture(named: "course_\(components[1])")
        case (.post, 5) where components[0] == "courses" && components[2] == "lessons" && components[4] == "complete":
            return Data("{}".utf8)
        default:
            throw NetworkError.notFound
        }
    }

    private func login(body: Data?) throws -> Data {
        guard
            let body,
            let request = try? JSONDecoder().decode(LoginRequest.self, from: body),
            request.password == Self.demoPassword
        else { throw NetworkError.unauthorized }
        let response = LoginResponse(email: request.email, token: UUID().uuidString)
        return try JSONEncoder().encode(response)
    }

    private func courses() throws -> Data {
        switch scenario {
        case .normal: try fixture(named: "courses")
        case .emptyCourses: Data("[]".utf8)
        case .serverError: throw NetworkError.server(statusCode: 500)
        }
    }

    private func fixture(named name: String) throws -> Data {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
            throw NetworkError.notFound
        }
        return try Data(contentsOf: url)
    }
}

private struct LoginRequest: Decodable {
    let email: String
    let password: String
}

private struct LoginResponse: Encodable {
    let email: String
    let token: String
}
