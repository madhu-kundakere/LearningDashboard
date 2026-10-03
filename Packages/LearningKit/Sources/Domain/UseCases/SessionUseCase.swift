public protocol SessionUseCase: Sendable {
    func restore() async -> AuthSession?
    func logout() async
}

public struct DefaultSessionUseCase: SessionUseCase {
    private let authRepository: any AuthRepository
    private let courseRepository: any CourseRepository

    public init(authRepository: any AuthRepository, courseRepository: any CourseRepository) {
        self.authRepository = authRepository
        self.courseRepository = courseRepository
    }

    public func restore() async -> AuthSession? {
        await authRepository.storedSession()
    }

    public func logout() async {
        await authRepository.logout()
        try? await courseRepository.clearCache()
    }
}
