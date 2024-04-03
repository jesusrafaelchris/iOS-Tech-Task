//
//  ImageDownloaderTests.swift
//  MoneyBoxTests
//
//  Created by Christian Grinling on 03/04/2024.
//

import XCTest
@testable import MoneyBox

final class ImageDownloaderTests: XCTestCase {
    
    var sut: ImageDownloaderProtocol!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = ImageDownloader(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testImageReturnsDataIfSuccessful() async throws {
        // Given
        let expectedImage = UIImage(named: "moneyBoxLogo")!
        let url = URL(string: "https://example.com/image.jpg")!
        let imageData = expectedImage.pngData()!
        mockURLSession.result = .success(imageData)
        
        // When
        let downloadedImage = try await sut.downloadImage(from: url.absoluteString)
        
        // Then
        XCTAssertEqual(downloadedImage.pngData(), expectedImage.pngData())
    }
    
    func testInvalidURLThrowsError() {
        // Given
        let invalidURL: String? = nil
        mockURLSession.result = .failure(.invalidURL)
        let expectation = XCTestExpectation(description: "Invalid URL error thrown")
        
        // When
        Task {
            do {
                _ = try await sut.downloadImage(from: invalidURL)
                XCTFail("Error should be thrown")
            } catch {
                // Then
                XCTAssertEqual(error as? ImageDownloaderError, ImageDownloaderError.invalidURL)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testUnknownThrowsError() {
        // Given
        let invalidURL: String = "www.google.com"
        mockURLSession.result = .failure(.unknown)
        let expectation = XCTestExpectation(description: "Unknwon Data error thrown")
        
        // When
        Task {
            do {
                _ = try await sut.downloadImage(from: invalidURL)
                XCTFail("Error should be thrown")
            } catch {
                // Then
                XCTAssertEqual(error as? ImageDownloaderError, ImageDownloaderError.unknown)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
