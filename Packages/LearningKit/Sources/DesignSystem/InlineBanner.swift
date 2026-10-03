import SwiftUI

public struct InlineBanner: View {
    private let message: String
    private let systemImage: String
    private let tint: Color

    public init(message: String, systemImage: String, tint: Color = .orange) {
        self.message = message
        self.systemImage = systemImage
        self.tint = tint
    }

    public static var offline: InlineBanner {
        InlineBanner(message: Strings.Banner.offline, systemImage: SystemSymbol.offline)
    }

    public var body: some View {
        HStack(spacing: Spacing.small + Spacing.xSmall) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(tint, in: Circle())
            Text(message)
                .font(.footnote.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.small + Spacing.xSmall)
        .background(tint.opacity(0.14), in: RoundedRectangle(cornerRadius: Radius.field, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.field, style: .continuous)
                .stroke(tint.opacity(0.3), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}
