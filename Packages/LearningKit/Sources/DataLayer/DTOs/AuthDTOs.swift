import Domain

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct LoginResponseDTO: Decodable {
    let email: String
    let token: String
}

struct StoredSessionDTO: Codable {
    let email: String
    let token: String

    init(_ session: AuthSession) {
        email = session.email
        token = session.token
    }

    func toDomain() -> AuthSession {
        AuthSession(email: email, token: token)
    }
}
