import UIKit

protocol ImageDownloaderProtocol: AnyObject {
    func downloadImage(from url: String?) async throws -> UIImage
}

public enum ImageDownloaderError: Error {
    case invalidURL
    case invalidData
    case unknown
}

class ImageDownloader: ImageDownloaderProtocol {
    
    private var urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func downloadImage(from url: String?) async throws -> UIImage {
        guard let urlString = url, let URL = URL(string: urlString) else {
            throw ImageDownloaderError.invalidURL
        }
        
        do {
            let data = try await urlSession.dataTask(with: URL)
            guard let image = UIImage(data: data) else {
                throw ImageDownloaderError.invalidData
            }
            return image
        } catch {
            print("Error downloading Image: \(error)")
            throw ImageDownloaderError.unknown
        }
    }
}
