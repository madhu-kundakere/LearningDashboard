import Foundation

enum Strings {
    enum Error {
        static var offline: String { String(localized: "error.offline", bundle: .module) }
        static var invalidCredentials: String { String(localized: "error.invalidCredentials", bundle: .module) }
        static var unauthorized: String { String(localized: "error.unauthorized", bundle: .module) }
        static var notFound: String { String(localized: "error.notFound", bundle: .module) }
        static var server: String { String(localized: "error.server", bundle: .module) }
        static var decoding: String { String(localized: "error.decoding", bundle: .module) }
        static var persistence: String { String(localized: "error.persistence", bundle: .module) }
        static var unknown: String { String(localized: "error.unknown", bundle: .module) }
    }
}
