//
//  ImageFetcherTests.swift
//  ArticleWaveTests
//
//  Created by Yago Pereira on 14/5/24.
//

@testable import ArticleWave
import XCTest

final class ImageFetcherTests: XCTestCase {
    private var sut: ImageFetcher!
    private var sessionMock: URLSessionMock!
    private let url = URL(string: "http://example.com/image.png")!
    private let imageData = UIImage(systemName: "checkmark")!.pngData()!

    override func setUp() {
        super.setUp()
        sessionMock = URLSessionMock()
        sut = ImageFetcher(session: sessionMock)
    }

    override func tearDown() {
        sut = nil
        sessionMock = nil
        super.tearDown()
    }

    func test_givenImageInCache_whenFetchImage_shouldReturnCachedImage() {
        // Given
        let expectedImage = UIImage(data: imageData)!
        sut.imageCache.setObject(expectedImage, forKey: url as NSURL)

        // When
        let expectation = self.expectation(description: "Fetch image from cache")
        var fetchedImage: UIImage?
        sut.fetch(url: url) { result in
            if case .success(let image) = result {
                fetchedImage = image
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(fetchedImage, expectedImage)
    }

    func test_givenImageNotInCache_whenFetchImage_shouldDownloadAndReturnImage() {
        // Given
        let expectedImage = UIImage(data: imageData)!
        sessionMock.nextData = imageData

        // When
        let expectation = self.expectation(description: "Fetch image from network")
        var fetchedImage: UIImage?
        sut.fetch(url: url) { result in
            if case .success(let image) = result {
                fetchedImage = image
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(compareImages(image1: fetchedImage, image2: expectedImage))
    }

    func test_givenNetworkError_whenFetchImage_shouldReturnError() {
        // Given
        sessionMock.nextError = NSError(domain: "NetworkError", code: 0, userInfo: nil)

        // When
        let expectation = self.expectation(description: "Fetch image from network failure")
        var fetchError: ImageFetcherError?
        sut.fetch(url: url) { result in
            if case .failure(let error) = result {
                fetchError = error
            }
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(fetchError, .invalidData)
    }

    func test_givenActiveDownload_whenCancelFetchImage_shouldCancelDownload() {
        // Given
        let task = URLSessionDataTaskMock()
        sut.currentTasks[url] = task

        // When
        sut.cancel(url: url)

        // Then
        XCTAssertTrue(task.cancelCalled)
        XCTAssertNil(sut.currentTasks[url])
    }

    private func compareImages(image1: UIImage?, image2: UIImage?) -> Bool {
        guard let data1 = image1?.pngData(), let data2 = image2?.pngData() else {
            return false
        }
        return data1 == data2
    }
}
