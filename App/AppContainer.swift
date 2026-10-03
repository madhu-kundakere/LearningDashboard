import AuthFeature
import Core
import CoursesFeature
import DataLayer
import Domain
import MockBackend
import Networking
import Persistence
import os

@MainActor
final class AppContainer {
    let sessionUseCase: any SessionUseCase
    private let loginUseCase: any LoginUseCase
    private let fetchCoursesUseCase: any FetchCoursesUseCase
    private let getCourseDetailUseCase: any GetCourseDetailUseCase
    private let completeLessonUseCase: any CompleteLessonUseCase

    init(environment: AppEnvironment) {
        let reachability: any ReachabilityMonitoring = environment.forcesOffline
            ? AlwaysOfflineReachability()
            : NetworkPathMonitor()
        let httpClient = MockBackendHTTPClient(reachability: reachability, scenario: environment.mockScenario)
        let stack = Self.makeCoreDataStack(inMemory: environment.usesInMemoryStorage)

        let authRepository = DefaultAuthRepository(
            client: httpClient,
            secureStore: KeychainSecureStore(service: AppConstants.Keychain.sessionService)
        )
        let courseRepository = DefaultCourseRepository(
            remote: APICourseRemoteDataSource(client: httpClient),
            local: CoreDataCourseLocalDataSource(stack: stack)
        )

        sessionUseCase = DefaultSessionUseCase(authRepository: authRepository, courseRepository: courseRepository)
        loginUseCase = DefaultLoginUseCase(repository: authRepository)
        fetchCoursesUseCase = DefaultFetchCoursesUseCase(repository: courseRepository)
        getCourseDetailUseCase = DefaultGetCourseDetailUseCase(repository: courseRepository)
        completeLessonUseCase = DefaultCompleteLessonUseCase(repository: courseRepository)
    }

    func makeLoginViewModel(onLoginSucceeded: @escaping @MainActor (AuthSession) -> Void) -> LoginViewModel {
        LoginViewModel(loginUseCase: loginUseCase, onLoginSucceeded: onLoginSucceeded)
    }

    func makeCourseListViewModel() -> CourseListViewModel {
        CourseListViewModel(fetchCourses: fetchCoursesUseCase)
    }

    func makeCourseDetailViewModel(course: Course) -> CourseDetailViewModel {
        CourseDetailViewModel(
            course: course,
            getCourseDetail: getCourseDetailUseCase,
            completeLesson: completeLessonUseCase
        )
    }

    private static func makeCoreDataStack(inMemory: Bool) -> CoreDataStack {
        do {
            return try CoreDataStack(kind: inMemory ? .inMemory : .persistent)
        } catch {
            Logger(subsystem: AppConstants.Logging.subsystem, category: AppConstants.Logging.containerCategory)
                .fault("Falling back to in-memory cache: \(error.localizedDescription)")
        }
        do {
            return try CoreDataStack(kind: .inMemory)
        } catch {
            fatalError("Unable to create any Core Data store: \(error)")
        }
    }
}
