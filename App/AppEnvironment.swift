import Foundation
import MockBackend

struct AppEnvironment {
    let mockScenario: MockScenario
    let forcesOffline: Bool
    let usesInMemoryStorage: Bool

    static func current(defaults: UserDefaults = .standard) -> AppEnvironment {
        AppEnvironment(
            mockScenario: defaults.string(forKey: AppConstants.LaunchArgument.mockScenario).flatMap(MockScenario.init(rawValue:)) ?? .normal,
            forcesOffline: defaults.bool(forKey: AppConstants.LaunchArgument.mockOffline),
            usesInMemoryStorage: defaults.bool(forKey: AppConstants.LaunchArgument.inMemoryStorage)
        )
    }
}
