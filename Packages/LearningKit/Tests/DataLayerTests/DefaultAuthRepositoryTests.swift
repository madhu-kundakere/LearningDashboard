import Core
import DataLayer
import Foundation
import Networking
import Persistence
import Testing

struct DefaultAuthRepositoryTests {
    @Test func successfulLoginPersistsSessionInSecureStore() async throws {
        let store = InMemorySecureStore()
        let client = StubHTTPClient { _ in Data(#"{"email":"learner@example.com","token":"abc"}"#.utf8) }
        let repository = DefaultAuthRepository(client: client, secureStore: store)

        let session = try await repository.login(email: "learner@example.com", password: "password123")

        #expect(session.token == "abc")
        #expect(await repository.storedSession() == session)
    }

    @Test func unauthorizedResponseMapsToInvalidCredentials() async {
        let client = StubHTTPClient { _ in throw NetworkError.unauthorized }
        let repository = DefaultAuthRepository(client: client, secureStore: InMemorySecureStore())

        await #expect(throws: AppError.invalidCredentials) {
            try await repository.login(email: "learner@example.com", password: "wrong-password")
        }
    }

    @Test func logoutRemovesStoredSession() async throws {
        let client = StubHTTPClient { _ in Data(#"{"email":"learner@example.com","token":"abc"}"#.utf8) }
        let repository = DefaultAuthRepository(client: client, secureStore: InMemorySecureStore())
        _ = try await repository.login(email: "learner@example.com", password: "password123")

        await repository.logout()

        #expect(await repository.storedSession() == nil)
    }
}
