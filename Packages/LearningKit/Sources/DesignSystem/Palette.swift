import SwiftUI

public struct AccentStyle: Sendable {
    public let primary: Color
    public let secondary: Color

    public init(primary: Color, secondary: Color) {
        self.primary = primary
        self.secondary = secondary
    }

    public var gradient: LinearGradient {
        LinearGradient(colors: [primary, secondary], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

public enum Palette {
    public static let brand = AccentStyle(
        primary: Color(red: 0.35, green: 0.30, blue: 0.96),
        secondary: Color(red: 0.70, green: 0.32, blue: 0.92)
    )

    public static let success = Color(red: 0.18, green: 0.72, blue: 0.45)

    public static let accents: [AccentStyle] = [
        AccentStyle(primary: Color(red: 0.25, green: 0.47, blue: 0.98), secondary: Color(red: 0.42, green: 0.30, blue: 0.95)),
        AccentStyle(primary: Color(red: 0.96, green: 0.36, blue: 0.55), secondary: Color(red: 0.99, green: 0.58, blue: 0.30)),
        AccentStyle(primary: Color(red: 0.10, green: 0.70, blue: 0.68), secondary: Color(red: 0.22, green: 0.52, blue: 0.95)),
        AccentStyle(primary: Color(red: 0.98, green: 0.55, blue: 0.18), secondary: Color(red: 0.95, green: 0.32, blue: 0.32)),
        AccentStyle(primary: Color(red: 0.55, green: 0.33, blue: 0.95), secondary: Color(red: 0.90, green: 0.35, blue: 0.75)),
    ]

    public static func accent(at index: Int) -> AccentStyle {
        accents[((index % accents.count) + accents.count) % accents.count]
    }
}
