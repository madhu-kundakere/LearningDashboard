import Core
import Domain
import Foundation
import Networking
import Persistence

public struct DefaultAuthRepository: AuthRepository {
    private static let sessionKey = "auth.session"

    private let client: any HTTPClient
    private let secureStore: any SecureStore

    public init(client: any HTTPClient, secureStore: any SecureStore) {
        self.client = client
        self.secureStore = secureStore
    }

    public func login(email: String, password: String) async throws -> AuthSession {
        do {
            let body = try JSONEncoder().encode(LoginRequestDTO(email: email, password: password))
            let response = try await client.send(
                Endpoint(path: "auth/login", method: .post, body: body),
                decoding: LoginResponseDTO.self
            )
            let session = AuthSession(email: response.email, token: response.token)
            try secureStore.set(JSONEncoder().encode(StoredSessionDTO(session)), for: Self.sessionKey)
            return session
        } catch NetworkError.unauthorized {
            throw AppError.invalidCredentials
        } catch {
            throw AppError(mapping: error)
        }
    }

    public func storedSession() async -> AuthSession? {
        guard let data = try? secureStore.data(for: Self.sessionKey) else { return nil }
        return try? JSONDecoder().decode(StoredSessionDTO.self, from: data).toDomain()
    }

    public func logout() async {
        try? secureStore.removeValue(for: Self.sessionKey)
    }
}
