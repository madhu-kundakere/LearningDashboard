import SwiftUI

public struct LoadingStateView: View {
    private let message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: Spacing.medium) {
            ProgressView()
                .controlSize(.large)
                .tint(Palette.brand.primary)
            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(Spacing.xLarge)
        .card()
        .fixedSize()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}
