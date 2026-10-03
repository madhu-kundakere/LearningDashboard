import Foundation

public protocol HTTPClient: Sendable {
    func send(_ endpoint: Endpoint) async throws -> Data
}

extension HTTPClient {
    public func send<Response: Decodable>(
        _ endpoint: Endpoint,
        decoding type: Response.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> Response {
        let data = try await send(endpoint)
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
}
