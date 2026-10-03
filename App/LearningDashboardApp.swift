import SwiftUI

@main
struct LearningDashboardApp: App {
    @State private var container: AppContainer
    @State private var router: AppRouter

    init() {
        let container = AppContainer(environment: .current())
        _container = State(initialValue: container)
        _router = State(initialValue: AppRouter(sessionUseCase: container.sessionUseCase))
    }

    var body: some Scene {
        WindowGroup {
            RootView(container: container, router: router)
        }
    }
}
