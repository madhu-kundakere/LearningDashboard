import SwiftUI

public enum Radius {
    public static let card: CGFloat = 20
    public static let field: CGFloat = 12
}

private struct CardModifier: ViewModifier {
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color(uiColor: .secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
            )
            .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 6)
    }
}

private struct GradientCardModifier: ViewModifier {
    let style: AccentStyle

    func body(content: Content) -> some View {
        content
            .padding(Spacing.large)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.white)
            .background(style.gradient, in: RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
            .shadow(color: style.primary.opacity(0.35), radius: 16, x: 0, y: 8)
    }
}

extension View {
    public func card(padding: CGFloat = Spacing.medium) -> some View {
        modifier(CardModifier(padding: padding))
    }

    public func gradientCard(_ style: AccentStyle) -> some View {
        modifier(GradientCardModifier(style: style))
    }
}
