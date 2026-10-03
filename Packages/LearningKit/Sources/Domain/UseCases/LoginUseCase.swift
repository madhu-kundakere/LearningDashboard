import Foundation

public protocol LoginUseCase: Sendable {
    func execute(email: String, password: String) async throws -> AuthSession
}

public struct DefaultLoginUseCase: LoginUseCase {
    private let repository: any AuthRepository

    public init(repository: any AuthRepository) {
        self.repository = repository
    }

    public func execute(email: String, password: String) async throws -> AuthSession {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return try await repository.login(email: normalizedEmail, password: password)
    }
}
