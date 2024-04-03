import Foundation
import MoneyBox

class MockURLSession: URLSessionProtocol {
    var result = Result<Data, ImageDownloaderError>.success(Data())
    
    func dataTask(with url: URL) async throws -> Data {
        try result.get()
    }
}
