public protocol ReachabilityMonitoring: Sendable {
    var isConnected: Bool { get }
}
