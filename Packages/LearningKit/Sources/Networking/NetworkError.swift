public enum NetworkError: Error, Equatable, Sendable {
    case offline
    case unauthorized
    case notFound
    case server(statusCode: Int)
    case decoding
    case transport
}
