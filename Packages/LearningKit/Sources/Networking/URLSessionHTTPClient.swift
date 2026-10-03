import Foundation

public struct URLSessionHTTPClient: HTTPClient {
    private let baseURL: URL
    private let session: URLSession

    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func send(_ endpoint: Endpoint) async throws -> Data {
        var request = URLRequest(url: baseURL.appending(path: endpoint.path))
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where Self.offlineCodes.contains(error.code) {
            throw NetworkError.offline
        } catch {
            throw NetworkError.transport
        }

        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.transport }
        switch httpResponse.statusCode {
        case 200..<300: return data
        case 401, 403: throw NetworkError.unauthorized
        case 404: throw NetworkError.notFound
        default: throw NetworkError.server(statusCode: httpResponse.statusCode)
        }
    }

    private static let offlineCodes: Set<URLError.Code> = [
        .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .timedOut,
    ]
}
