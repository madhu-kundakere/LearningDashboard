import Domain
import Observation

enum Route: Hashable {
    case courseDetail(Course)
}

@MainActor
@Observable
final class AppRouter {
    enum Phase: Equatable {
        case launching
        case loggedOut
        case loggedIn(AuthSession)
    }

    private(set) var phase: Phase = .launching
    var path: [Route] = []

    private let sessionUseCase: any SessionUseCase

    init(sessionUseCase: any SessionUseCase) {
        self.sessionUseCase = sessionUseCase
    }

    func restoreSession() async {
        guard phase == .launching else { return }
        phase = await sessionUseCase.restore().map(Phase.loggedIn) ?? .loggedOut
    }

    func didLogIn(_ session: AuthSession) {
        path = []
        phase = .loggedIn(session)
    }

    func logOut() async {
        await sessionUseCase.logout()
        path = []
        phase = .loggedOut
    }

    func showCourse(_ course: Course) {
        path.append(.courseDetail(course))
    }
}
