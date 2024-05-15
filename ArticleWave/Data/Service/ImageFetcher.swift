//
//  ImageFetcher.swift
//  ArticleWave
//
//  Created by Yago Pereira on 14/5/24.
//

import UIKit

protocol ImageFetcherType {
    func fetch(
        url: URL,
        _ completionHandler: @escaping (Result<UIImage,ImageFetcherError>) -> Void
    )

    func cancel(url: URL)
}

/// `ImageFetcher` is a singleton class responsible for fetching images from the web and caching them.
/// It allows images to be loaded asynchronously and reused without needing to download them again.
///
/// - Properties:
///   - `currentTasks`: A dictionary that keeps track of ongoing image download tasks, using the URL as the key.
///   - `shared`: The singleton instance of `ImageFetcher`.
///   - `imageCache`: A cache for storing downloaded images, using the URL as the key.
///   - `session`: The URL session used to perform download requests.
///
/// - Methods:
///   - `fetch(url: URL, _ completionHandler: @escaping (Result<UIImage, ImageFetcherError>) -> Void)`:
///     Downloads an image from a URL. If the image is already cached, it returns it directly.
///   - `cancel(url: URL)`:
///     Cancels the download task for a specific URL.
///
/// `ImageFetcherError` is an enum that represents the possible errors that can occur while downloading an image.

final class ImageFetcher: ImageFetcherType {
    // MARK: - Properties
    var currentTasks: [URL: URLSessionDataTask] = [:]
    static let shared = ImageFetcher()
    private(set) var imageCache: NSCache<NSURL, UIImage> = NSCache()
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - Methods
    func fetch(url: URL, _ completionHandler: @escaping (Result<UIImage, ImageFetcherError>) -> Void) {
        if let image = imageCache.object(forKey: url as NSURL) {
            completionHandler(.success(image))
        } else {
            let task = session.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    self?.imageCache.setObject(image, forKey: url as NSURL)
                    completionHandler(.success(image))
                } else {
                    completionHandler(.failure(.invalidData))
                }
            }
            currentTasks[url] = task
            task.resume()
        }
    }

    func cancel(url: URL) {
        currentTasks[url]?.cancel()
        currentTasks[url] = nil
    }
}

enum ImageFetcherError: Error {
    case invalidData
}
