import Domain
import Testing

struct ProgressCalculatorTests {
    @Test(arguments: [
        (completed: 13, total: 20, expected: 65),
        (completed: 14, total: 20, expected: 70),
        (completed: 7, total: 16, expected: 44),
        (completed: 0, total: 28, expected: 0),
        (completed: 28, total: 28, expected: 100),
    ])
    func percentageRoundsToNearestWholeNumber(completed: Int, total: Int, expected: Int) {
        #expect(ProgressCalculator.percentage(completed: completed, total: total) == expected)
    }

    @Test func percentageIsZeroWhenCourseHasNoLessons() {
        #expect(ProgressCalculator.percentage(completed: 0, total: 0) == 0)
    }

    @Test func percentageIsClampedToValidRange() {
        #expect(ProgressCalculator.percentage(completed: 30, total: 20) == 100)
        #expect(ProgressCalculator.percentage(completed: -1, total: 20) == 0)
    }
}
