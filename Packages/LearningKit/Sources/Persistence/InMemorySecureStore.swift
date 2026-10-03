import Foundation
import os

public final class InMemorySecureStore: SecureStore {
    private let storage = OSAllocatedUnfairLock(initialState: [String: Data]())

    public init() {}

    public func data(for key: String) throws -> Data? {
        storage.withLock { $0[key] }
    }

    public func set(_ data: Data, for key: String) throws {
        storage.withLock { $0[key] = data }
    }

    public func removeValue(for key: String) throws {
        _ = storage.withLock { $0.removeValue(forKey: key) }
    }
}
