import Core

public struct AlwaysOfflineReachability: ReachabilityMonitoring {
    public init() {}

    public var isConnected: Bool { false }
}
