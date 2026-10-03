import SwiftUI

public struct IconTile: View {
    private let systemImage: String
    private let style: AccentStyle
    private let size: CGFloat

    public init(systemImage: String, style: AccentStyle, size: CGFloat = 52) {
        self.systemImage = systemImage
        self.style = style
        self.size = size
    }

    public var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(style.gradient, in: RoundedRectangle(cornerRadius: size * 0.3, style: .continuous))
            .shadow(color: style.primary.opacity(0.35), radius: 8, x: 0, y: 4)
            .accessibilityHidden(true)
    }
}
