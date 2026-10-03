import Core
import Foundation
import Networking

extension AppError {
    init(mapping error: any Error) {
        switch error {
        case let appError as AppError:
            self = appError
        case let networkError as NetworkError:
            self = Self(networkError)
        case let nsError as NSError where nsError.domain == NSCocoaErrorDomain:
            self = .persistence
        default:
            self = .unknown
        }
    }

    private init(_ error: NetworkError) {
        switch error {
        case .offline, .transport: self = .offline
        case .unauthorized: self = .unauthorized
        case .notFound: self = .notFound
        case .server(let statusCode): self = .server(statusCode: statusCode)
        case .decoding: self = .decoding
        }
    }
}
