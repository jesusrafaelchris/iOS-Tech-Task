import UIKit

protocol ImageDownloaderProtocol: AnyObject {
    func downloadImage(from url: URL) async throws -> UIImage
}

class ImageDownloader: ImageDownloaderProtocol {
    
    func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageDownloadError.invalidImageData
        }
        return image
    }

    enum ImageDownloadError: Error {
        case invalidImageData
    }
}

