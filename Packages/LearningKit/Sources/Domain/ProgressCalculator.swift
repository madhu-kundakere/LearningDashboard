public enum ProgressCalculator {
    public static func percentage(completed: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        let clampedCompleted = min(max(completed, 0), total)
        return Int((Double(clampedCompleted) / Double(total) * 100).rounded())
    }
}
