//
//  ImageFetcherMock.swift
//  ArticleWaveTests
//
//  Created by Yago Pereira on 14/5/24.
//

@testable import ArticleWave
import UIKit

class ImageFetcherMock: ImageFetcherType {
    var fetchCalled = false
    var cancelCalled = false
    var nextResult: Result<UIImage, ImageFetcherError>?
    private var fetchedURLs: [URL] = []
    var imageCache = NSCache<NSURL, UIImage>()

    func fetch(
        url: URL,
        _ completionHandler: @escaping (Result<UIImage, ImageFetcherError>) -> Void
    ) {
        fetchCalled = true
        fetchedURLs.append(url)
        if let image = imageCache.object(forKey: url as NSURL) {
            completionHandler(.success(image))
        } else if let result = nextResult {
            completionHandler(result)
        }
    }

    func cancel(url: URL) {
        cancelCalled = true
    }
}
