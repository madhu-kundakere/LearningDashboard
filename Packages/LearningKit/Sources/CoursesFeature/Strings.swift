import Foundation

enum Strings {
    enum CourseList {
        static var title: String { String(localized: "courses.title", bundle: .module) }
        static var loading: String { String(localized: "courses.loading", bundle: .module) }
        static var emptyTitle: String { String(localized: "courses.empty.title", bundle: .module) }
        static var emptyMessage: String { String(localized: "courses.empty.message", bundle: .module) }
        static var errorTitle: String { String(localized: "courses.error.title", bundle: .module) }
        static var refreshFailed: String { String(localized: "courses.refreshFailed", bundle: .module) }
        static var continueAction: String { String(localized: "courses.continue", bundle: .module) }
        static var summaryTitle: String { String(localized: "courses.summary.title", bundle: .module) }

        static func summarySubtitle(courseCount: Int) -> String {
            String(localized: "courses.summary.subtitle \(courseCount)", bundle: .module)
        }

        static func lessonCount(_ count: Int) -> String {
            String(localized: "courses.lessonCount \(count)", bundle: .module)
        }

        static func instructor(_ name: String) -> String {
            String(localized: "courses.instructor \(name)", bundle: .module)
        }
    }

    enum CourseDetail {
        static var loading: String { String(localized: "detail.loading", bundle: .module) }
        static var errorTitle: String { String(localized: "detail.error.title", bundle: .module) }
        static var lessons: String { String(localized: "detail.lessons", bundle: .module) }
        static var completed: String { String(localized: "detail.completed", bundle: .module) }
        static var pending: String { String(localized: "detail.pending", bundle: .module) }
        static var markComplete: String { String(localized: "detail.markComplete", bundle: .module) }
        static var actionFailed: String { String(localized: "detail.actionFailed", bundle: .module) }
        static var ok: String { String(localized: "detail.ok", bundle: .module) }

        static func summary(completed: Int, total: Int) -> String {
            String(localized: "detail.summary \(completed) \(total)", bundle: .module)
        }
    }
}
