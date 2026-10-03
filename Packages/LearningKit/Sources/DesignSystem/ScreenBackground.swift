import SwiftUI

private struct ScreenBackground: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
            LinearGradient(
                colors: [Palette.brand.primary.opacity(0.16), Palette.brand.secondary.opacity(0.06), .clear],
                startPoint: .top,
                endPoint: .center
            )
        }
        .ignoresSafeArea()
    }
}

extension View {
    public func screenBackground() -> some View {
        background(ScreenBackground())
    }
}
