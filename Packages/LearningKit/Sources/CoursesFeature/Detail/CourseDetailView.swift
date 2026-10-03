import Core
import DesignSystem
import Domain
import SwiftUI

public struct CourseDetailView: View {
    @Bindable private var viewModel: CourseDetailViewModel

    public init(viewModel: CourseDetailViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .screenBackground()
            .navigationTitle(viewModel.course.title)
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
            .alert(
                Strings.CourseDetail.actionFailed,
                isPresented: isShowingActionError
            ) {
                Button(Strings.CourseDetail.ok, role: .cancel) {}
            } message: {
                Text(viewModel.actionErrorMessage ?? "")
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingStateView(message: Strings.CourseDetail.loading)
        case .empty:
            MessageStateView(
                systemImage: Symbols.emptyLessons,
                title: Strings.CourseDetail.errorTitle,
                message: AppError.notFound.localizedDescription,
                retry: retry
            )
        case .failed(let error):
            MessageStateView(
                systemImage: error == .offline ? SystemSymbol.offline : SystemSymbol.warning,
                title: Strings.CourseDetail.errorTitle,
                message: error.localizedDescription,
                retry: retry
            )
        case .loaded(let detail):
            lessonList(detail)
        }
    }

    private func lessonList(_ detail: CourseDetail) -> some View {
        let appearance = CourseAppearance(course: detail.course)
        return ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.small + Spacing.xSmall) {
                if viewModel.refreshError == .offline {
                    InlineBanner.offline
                }
                CourseDetailHeader(detail: detail, appearance: appearance)
                Text(Strings.CourseDetail.lessons)
                    .font(.title3.bold())
                    .padding(.top, Spacing.small)
                    .accessibilityAddTraits(.isHeader)
                ForEach(Array(detail.lessons.enumerated()), id: \.element.id) { index, lesson in
                    LessonRow(
                        lesson: lesson,
                        number: index + 1,
                        style: appearance.style,
                        isUpdating: viewModel.completingLessonIDs.contains(lesson.id),
                        onComplete: { complete(lesson) }
                    )
                }
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.small)
        }
        .refreshable { await viewModel.load() }
    }

    private var isShowingActionError: Binding<Bool> {
        Binding(
            get: { viewModel.actionErrorMessage != nil },
            set: { if !$0 { viewModel.actionErrorMessage = nil } }
        )
    }

    private func complete(_ lesson: Lesson) {
        Task { await viewModel.completeLesson(lesson.id) }
    }

    private func retry() {
        Task { await viewModel.load() }
    }
}

private struct CourseDetailHeader: View {
    let detail: CourseDetail
    let appearance: CourseAppearance

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack(alignment: .top, spacing: Spacing.medium) {
                Image(systemName: appearance.systemImage)
                    .font(.title2.weight(.semibold))
                    .frame(width: 52, height: 52)
                    .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: Spacing.xSmall) {
                    Text(detail.course.title)
                        .font(.title2.bold())
                    Text(Strings.CourseList.instructor(detail.course.instructor))
                        .font(.subheadline)
                        .opacity(0.9)
                }
            }
            HStack(spacing: Spacing.medium) {
                ProgressRing(percentage: detail.course.progress)
                    .frame(width: 76, height: 76)
                Text(Strings.CourseDetail.summary(completed: detail.completedLessonCount, total: detail.lessons.count))
                    .font(.subheadline.weight(.semibold))
            }
        }
        .gradientCard(appearance.style)
    }
}
