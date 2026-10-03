import Foundation

public enum AppError: Error, Equatable, Sendable {
    case offline
    case invalidCredentials
    case unauthorized
    case notFound
    case server(statusCode: Int)
    case decoding
    case persistence
    case unknown

    public init(_ error: any Error) {
        self = error as? AppError ?? .unknown
    }
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .offline:
            Strings.Error.offline
        case .invalidCredentials:
            Strings.Error.invalidCredentials
        case .unauthorized:
            Strings.Error.unauthorized
        case .notFound:
            Strings.Error.notFound
        case .server:
            Strings.Error.server
        case .decoding:
            Strings.Error.decoding
        case .persistence:
            Strings.Error.persistence
        case .unknown:
            Strings.Error.unknown
        }
    }
}
