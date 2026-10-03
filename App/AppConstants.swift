import Foundation

enum AppConstants {
    enum Strings {
        static var logout: String { String(localized: "app.logout") }
    }

    enum LaunchArgument {
        static let mockScenario = "mockScenario"
        static let mockOffline = "mockOffline"
        static let inMemoryStorage = "inMemoryStorage"
    }

    enum Keychain {
        static let sessionService = "com.example.learningdashboard.session"
    }

    enum Logging {
        static let subsystem = "LearningDashboard"
        static let containerCategory = "AppContainer"
    }
}
