import Core
import DesignSystem
import Domain
import SwiftUI

public struct CourseListView: View {
    private let viewModel: CourseListViewModel
    private let onSelectCourse: (Course) -> Void

    public init(viewModel: CourseListViewModel, onSelectCourse: @escaping (Course) -> Void) {
        self.viewModel = viewModel
        self.onSelectCourse = onSelectCourse
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .screenBackground()
            .navigationTitle(Strings.CourseList.title)
            .task { await viewModel.onAppear() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingStateView(message: Strings.CourseList.loading)
        case .empty:
            MessageStateView(
                systemImage: Symbols.emptyCourses,
                title: Strings.CourseList.emptyTitle,
                message: Strings.CourseList.emptyMessage,
                retry: retry
            )
        case .failed(let error):
            MessageStateView(
                systemImage: error == .offline ? SystemSymbol.offline : SystemSymbol.warning,
                title: Strings.CourseList.errorTitle,
                message: error.localizedDescription,
                retry: retry
            )
        case .loaded(let courses):
            courseList(courses)
        }
    }

    private func courseList(_ courses: [Course]) -> some View {
        ScrollView {
            LazyVStack(spacing: Spacing.medium) {
                if let refreshError = viewModel.refreshError {
                    refreshBanner(for: refreshError)
                }
                CoursesSummaryCard(courses: courses)
                ForEach(courses) { course in
                    Button { onSelectCourse(course) } label: {
                        CourseRow(course: course)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.small)
        }
        .refreshable { await viewModel.refresh() }
    }

    private func refreshBanner(for error: AppError) -> InlineBanner {
        if error == .offline {
            return .offline
        }
        return InlineBanner(
            message: Strings.CourseList.refreshFailed,
            systemImage: SystemSymbol.refreshFailed
        )
    }

    private func retry() {
        Task { await viewModel.load() }
    }
}
