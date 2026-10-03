import Foundation

enum Strings {
    enum State {
        static var retry: String { String(localized: "state.retry", bundle: .module) }
    }

    enum Banner {
        static var offline: String { String(localized: "banner.offline", bundle: .module) }
    }

    enum Progress {
        static func accessibilityLabel(_ formattedPercentage: String) -> String {
            String(localized: "progress.accessibility \(formattedPercentage)", bundle: .module)
        }
    }
}
