public enum EmailValidationError: Error, Equatable, Sendable {
    case empty
    case invalidFormat
}

public enum PasswordValidationError: Error, Equatable, Sendable {
    case empty
    case tooShort(minimumLength: Int)
}

public struct CredentialsValidator: Sendable {
    public let minimumPasswordLength: Int

    public init(minimumPasswordLength: Int = 6) {
        self.minimumPasswordLength = minimumPasswordLength
    }

    public func validateEmail(_ email: String) -> EmailValidationError? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .empty }
        let pattern = #/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/#
        return trimmed.wholeMatch(of: pattern) == nil ? .invalidFormat : nil
    }

    public func validatePassword(_ password: String) -> PasswordValidationError? {
        guard !password.isEmpty else { return .empty }
        return password.count < minimumPasswordLength ? .tooShort(minimumLength: minimumPasswordLength) : nil
    }
}
