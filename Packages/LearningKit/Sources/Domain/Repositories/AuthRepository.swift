public protocol AuthRepository: Sendable {
    func login(email: String, password: String) async throws -> AuthSession
    func storedSession() async -> AuthSession?
    func logout() async
}
