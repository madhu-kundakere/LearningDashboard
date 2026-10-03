import Core
import Network
import os

public final class NetworkPathMonitor: ReachabilityMonitoring {
    private let monitor = NWPathMonitor()
    private let state = OSAllocatedUnfairLock(initialState: true)

    public init() {
        monitor.pathUpdateHandler = { [state] path in
            state.withLock { $0 = path.status == .satisfied }
        }
        monitor.start(queue: DispatchQueue(label: "NetworkPathMonitor"))
    }

    deinit {
        monitor.cancel()
    }

    public var isConnected: Bool {
        state.withLock { $0 }
    }
}
