import SwiftUI

public struct MessageStateView: View {
    private let systemImage: String
    private let title: String
    private let message: String
    private let style: AccentStyle
    private let retry: (() -> Void)?

    public init(
        systemImage: String,
        title: String,
        message: String,
        style: AccentStyle = Palette.brand,
        retry: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.style = style
        self.retry = retry
    }

    public var body: some View {
        VStack(spacing: Spacing.medium) {
            IconTile(systemImage: systemImage, style: style, size: 72)
            Text(title)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if let retry {
                PrimaryButton(Strings.State.retry, action: retry)
                    .padding(.top, Spacing.small)
            }
        }
        .frame(maxWidth: .infinity)
        .card(padding: Spacing.large)
        .padding(Spacing.large)
        .frame(maxHeight: .infinity)
    }
}
