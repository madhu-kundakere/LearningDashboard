import AuthFeature
import Core
import Domain
import Testing

@MainActor
struct LoginViewModelTests {
    @Test func invalidInputShowsFieldErrorsWithoutCallingLogin() async {
        let useCase = LoginUseCaseStub(result: .success(Self.session))
        let viewModel = LoginViewModel(loginUseCase: useCase, onLoginSucceeded: { _ in })
        viewModel.email = "not-an-email"
        viewModel.password = "123"

        await viewModel.submit()

        #expect(viewModel.emailError != nil)
        #expect(viewModel.passwordError != nil)
        #expect(await useCase.callCount == 0)
    }

    @Test func successfulLoginNotifiesCoordinator() async {
        var loggedInSession: AuthSession?
        let viewModel = LoginViewModel(
            loginUseCase: LoginUseCaseStub(result: .success(Self.session)),
            onLoginSucceeded: { loggedInSession = $0 }
        )
        viewModel.email = "learner@example.com"
        viewModel.password = "password123"

        await viewModel.submit()

        #expect(loggedInSession == Self.session)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test func failedLoginShowsErrorMessage() async {
        let viewModel = LoginViewModel(
            loginUseCase: LoginUseCaseStub(result: .failure(.invalidCredentials)),
            onLoginSucceeded: { _ in Issue.record("Login should not succeed") }
        )
        viewModel.email = "learner@example.com"
        viewModel.password = "wrong-password"

        await viewModel.submit()

        #expect(viewModel.errorMessage == AppError.invalidCredentials.localizedDescription)
        #expect(viewModel.isLoading == false)
    }

    private static let session = AuthSession(email: "learner@example.com", token: "token")
}

private actor LoginUseCaseStub: LoginUseCase {
    private let result: Result<AuthSession, AppError>
    private(set) var callCount = 0

    init(result: Result<AuthSession, AppError>) {
        self.result = result
    }

    func execute(email: String, password: String) async throws -> AuthSession {
        callCount += 1
        return try result.get()
    }
}
