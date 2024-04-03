import UIKit

public protocol URLSessionProtocol {
    func dataTask(with url: URL) async throws -> Data
}

extension URLSession: URLSessionProtocol {
    public func dataTask(with url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
