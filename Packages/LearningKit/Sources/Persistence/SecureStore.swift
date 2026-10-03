import Foundation

public protocol SecureStore: Sendable {
    func data(for key: String) throws -> Data?
    func set(_ data: Data, for key: String) throws
    func removeValue(for key: String) throws
}

public enum SecureStoreError: Error, Equatable, Sendable {
    case unexpectedStatus(OSStatus)
}
