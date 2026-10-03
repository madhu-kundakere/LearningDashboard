import Foundation

enum Strings {
    enum Login {
        static var title: String { String(localized: "login.title", bundle: .module) }
        static var subtitle: String { String(localized: "login.subtitle", bundle: .module) }
        static var email: String { String(localized: "login.email", bundle: .module) }
        static var password: String { String(localized: "login.password", bundle: .module) }
        static var submit: String { String(localized: "login.submit", bundle: .module) }
    }

    enum Validation {
        static var emailEmpty: String { String(localized: "login.error.emailEmpty", bundle: .module) }
        static var emailInvalid: String { String(localized: "login.error.emailInvalid", bundle: .module) }
        static var passwordEmpty: String { String(localized: "login.error.passwordEmpty", bundle: .module) }

        static func passwordTooShort(minimumLength: Int) -> String {
            String(localized: "login.error.passwordTooShort \(minimumLength)", bundle: .module)
        }
    }
}
