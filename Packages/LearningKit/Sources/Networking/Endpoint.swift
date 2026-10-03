import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
}

public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let body: Data?

    public init(path: String, method: HTTPMethod = .get, body: Data? = nil) {
        self.path = path
        self.method = method
        self.body = body
    }
}
