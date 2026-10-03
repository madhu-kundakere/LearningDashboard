import DesignSystem
import Domain
import SwiftUI

struct CoursesSummaryCard: View {
    let courses: [Course]

    var body: some View {
        HStack(spacing: Spacing.medium) {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(Strings.CourseList.summaryTitle)
                    .font(.title3.bold())
                Text(Strings.CourseList.summarySubtitle(courseCount: courses.count))
                    .font(.subheadline)
                    .opacity(0.9)
            }
            Spacer()
            ProgressRing(percentage: averageProgress)
                .frame(width: 72, height: 72)
        }
        .gradientCard(Palette.brand)
        .accessibilityElement(children: .combine)
    }

    private var averageProgress: Int {
        guard !courses.isEmpty else { return 0 }
        return courses.map(\.progress).reduce(0, +) / courses.count
    }
}
