//
//  URLSessionMock.swift
//  ArticleWaveTests
//
//  Created by Yago Pereira on 14/5/24.
//

@testable import ArticleWave
import Foundation

final class URLSessionMock: URLSession {
    var nextData: Data?
    var nextError: Error?
    var nextResponse: URLResponse?
    var dataTaskCalled = false
    var lastURL: URL?

    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        lastURL = request.url
        dataTaskCalled = true
        let task = URLSessionDataTaskMock(
            completionHandler: weakify {
                completionHandler($0.nextData, $0.nextResponse, $0.nextError)
            }
        )
        return task
    }
}

final class URLSessionDataTaskMock: URLSessionDataTask {
    var completionHandler: (() -> Void)?
    var cancelCalled = false

    init(completionHandler: (() -> Void)? = nil) {
        self.completionHandler = completionHandler
    }

    override func resume() {
        completionHandler?()
    }

    override func cancel() {
        cancelCalled = true
    }
}
