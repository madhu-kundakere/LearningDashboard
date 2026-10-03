import DesignSystem
import Domain
import SwiftUI

struct LessonRow: View {
    let lesson: Lesson
    let number: Int
    let style: AccentStyle
    let isUpdating: Bool
    let onComplete: () -> Void

    var body: some View {
        HStack(spacing: Spacing.medium) {
            HStack(spacing: Spacing.medium) {
                badge
                VStack(alignment: .leading, spacing: Spacing.xSmall + 2) {
                    Text(lesson.title)
                        .font(.subheadline.weight(.semibold))
                    statusPill
                }
            }
            .accessibilityElement(children: .combine)
            Spacer(minLength: Spacing.small)
            trailingAction
        }
        .card(padding: Spacing.medium - 2)
        .overlay {
            RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                .stroke(lesson.isCompleted ? Palette.success.opacity(0.35) : .clear, lineWidth: 1)
        }
    }

    @ViewBuilder
    private var badge: some View {
        if lesson.isCompleted {
            Image(systemName: SystemSymbol.checkmark)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Palette.success, in: Circle())
                .accessibilityHidden(true)
        } else {
            Text(number, format: .number)
                .font(.subheadline.weight(.bold).monospacedDigit())
                .foregroundStyle(style.primary)
                .frame(width: 36, height: 36)
                .background(style.primary.opacity(0.12), in: Circle())
                .accessibilityHidden(true)
        }
    }

    private var statusPill: some View {
        let tint = lesson.isCompleted ? Palette.success : Color.secondary
        return Text(statusText)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, Spacing.small)
            .padding(.vertical, 3)
            .background(tint.opacity(0.14), in: Capsule())
    }

    @ViewBuilder
    private var trailingAction: some View {
        if isUpdating {
            ProgressView()
                .tint(style.primary)
        } else if !lesson.isCompleted {
            Button(Strings.CourseDetail.markComplete, action: onComplete)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.small + Spacing.xSmall)
                .padding(.vertical, Spacing.small)
                .background(style.gradient, in: Capsule())
                .buttonStyle(.plain)
        }
    }

    private var statusText: String {
        lesson.isCompleted
            ? Strings.CourseDetail.completed
            : Strings.CourseDetail.pending
    }
}
