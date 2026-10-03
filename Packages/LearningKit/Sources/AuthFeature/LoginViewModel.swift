import Core
import Domain
import Foundation
import Observation

@MainActor
@Observable
public final class LoginViewModel {
    public var email = "" {
        didSet { emailError = nil }
    }
    public var password = "" {
        didSet { passwordError = nil }
    }
    public private(set) var emailError: String?
    public private(set) var passwordError: String?
    public private(set) var errorMessage: String?
    public private(set) var isLoading = false

    private let loginUseCase: any LoginUseCase
    private let validator: CredentialsValidator
    private let onLoginSucceeded: @MainActor (AuthSession) -> Void

    public init(
        loginUseCase: any LoginUseCase,
        validator: CredentialsValidator = CredentialsValidator(),
        onLoginSucceeded: @escaping @MainActor (AuthSession) -> Void
    ) {
        self.loginUseCase = loginUseCase
        self.validator = validator
        self.onLoginSucceeded = onLoginSucceeded
    }

    public func submit() async {
        guard !isLoading else { return }
        errorMessage = nil
        guard validateInput() else { return }

        isLoading = true
        defer { isLoading = false }
        do {
            let session = try await loginUseCase.execute(email: email, password: password)
            onLoginSucceeded(session)
        } catch {
            errorMessage = AppError(error).localizedDescription
        }
    }

    private func validateInput() -> Bool {
        emailError = validator.validateEmail(email).map(Self.message(for:))
        passwordError = validator.validatePassword(password).map(Self.message(for:))
        return emailError == nil && passwordError == nil
    }

    private static func message(for error: EmailValidationError) -> String {
        switch error {
        case .empty: Strings.Validation.emailEmpty
        case .invalidFormat: Strings.Validation.emailInvalid
        }
    }

    private static func message(for error: PasswordValidationError) -> String {
        switch error {
        case .empty: Strings.Validation.passwordEmpty
        case .tooShort(let minimumLength): Strings.Validation.passwordTooShort(minimumLength: minimumLength)
        }
    }
}
