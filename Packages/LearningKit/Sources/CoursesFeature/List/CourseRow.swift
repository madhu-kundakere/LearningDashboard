import DesignSystem
import Domain
import SwiftUI

struct CourseRow: View {
    let course: Course

    var body: some View {
        let appearance = CourseAppearance(course: course)
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack(alignment: .center, spacing: Spacing.medium) {
                IconTile(systemImage: appearance.systemImage, style: appearance.style)
                VStack(alignment: .leading, spacing: Spacing.xSmall) {
                    Text(course.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(Strings.CourseList.instructor(course.instructor))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            ProgressIndicator(percentage: course.progress, style: appearance.style)
            HStack {
                Label(
                    Strings.CourseList.lessonCount(course.lessonCount),
                    systemImage: Symbols.lessons
                )
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: Spacing.xSmall) {
                    Text(Strings.CourseList.continueAction)
                    Image(systemName: SystemSymbol.forwardArrow)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.small)
                .background(appearance.style.gradient, in: Capsule())
            }
        }
        .card()
        .contentShape(RoundedRectangle(cornerRadius: Radius.card))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
