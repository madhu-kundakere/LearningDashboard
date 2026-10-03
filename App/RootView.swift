import AuthFeature
import CoursesFeature
import SwiftUI

struct RootView: View {
    let container: AppContainer
    @Bindable var router: AppRouter

    var body: some View {
        Group {
            switch router.phase {
            case .launching:
                ProgressView()
            case .loggedOut:
                LoginScreen(viewModel: container.makeLoginViewModel(onLoginSucceeded: router.didLogIn))
            case .loggedIn(let session):
                DashboardFlow(container: container, router: router)
                    .id(session.token)
            }
        }
        .task { await router.restoreSession() }
    }
}

private struct DashboardFlow: View {
    let container: AppContainer
    @Bindable var router: AppRouter
    @State private var courseListViewModel: CourseListViewModel

    init(container: AppContainer, router: AppRouter) {
        self.container = container
        self.router = router
        _courseListViewModel = State(initialValue: container.makeCourseListViewModel())
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            CourseListView(viewModel: courseListViewModel, onSelectCourse: router.showCourse)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(AppConstants.Strings.logout) {
                            Task { await router.logOut() }
                        }
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .courseDetail(let course):
                        CourseDetailScreen(viewModel: container.makeCourseDetailViewModel(course: course))
                    }
                }
        }
    }
}

private struct CourseDetailScreen: View {
    @State var viewModel: CourseDetailViewModel

    var body: some View {
        CourseDetailView(viewModel: viewModel)
    }
}

private struct LoginScreen: View {
    @State var viewModel: LoginViewModel

    var body: some View {
        LoginView(viewModel: viewModel)
    }
}
