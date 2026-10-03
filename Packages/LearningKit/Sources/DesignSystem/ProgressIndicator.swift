import SwiftUI

public struct ProgressIndicator: View {
    private let percentage: Int
    private let style: AccentStyle

    public init(percentage: Int, style: AccentStyle = Palette.brand) {
        self.percentage = min(max(percentage, 0), 100)
        self.style = style
    }

    public var body: some View {
        let formatted = ProgressFormatting.percent(percentage)
        HStack(spacing: Spacing.small + Spacing.xSmall) {
            Capsule()
                .fill(style.primary.opacity(0.15))
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        Capsule()
                            .fill(style.gradient)
                            .frame(width: proxy.size.width * Double(percentage) / 100)
                    }
                }
                .frame(height: 8)
            Text(formatted)
                .font(.caption.weight(.semibold).monospacedDigit())
                .foregroundStyle(style.primary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ProgressFormatting.accessibilityLabel(percentage))
    }
}

public struct ProgressRing: View {
    private let percentage: Int
    private let lineWidth: CGFloat

    public init(percentage: Int, lineWidth: CGFloat = 8) {
        self.percentage = min(max(percentage, 0), 100)
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.25), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: Double(percentage) / 100)
                .stroke(.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(ProgressFormatting.percent(percentage))
                .font(.subheadline.weight(.bold).monospacedDigit())
                .minimumScaleFactor(0.6)
                .padding(lineWidth)
        }
        .foregroundStyle(.white)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ProgressFormatting.accessibilityLabel(percentage))
    }
}

enum ProgressFormatting {
    static func percent(_ percentage: Int) -> String {
        (Double(percentage) / 100).formatted(.percent.precision(.fractionLength(0)))
    }

    static func accessibilityLabel(_ percentage: Int) -> String {
        Strings.Progress.accessibilityLabel(percent(percentage))
    }
}
