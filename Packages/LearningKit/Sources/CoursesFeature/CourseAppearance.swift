import DesignSystem
import Domain

struct CourseAppearance {
    let style: AccentStyle
    let systemImage: String

    init(course: Course) {
        let index = course.id - 1
        style = Palette.accent(at: index)
        let icons = Symbols.courseIcons
        systemImage = icons[((index % icons.count) + icons.count) % icons.count]
    }
}
