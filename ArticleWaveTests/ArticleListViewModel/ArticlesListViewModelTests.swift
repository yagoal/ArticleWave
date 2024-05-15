//
//  ArticlesListViewModelTests.swift
//  ArticleWaveTests
//
//  Created by Yago Pereira on 11/5/24.
//

@testable import ArticleWave
import XCTest
import Combine

final class ArticlesListViewModelTests: XCTestCase {
    private var sut: ArticlesListViewModel!
    private var mockAPIManager: MockAPIManager!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        sut = ArticlesListViewModel(apiManager: mockAPIManager)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockAPIManager = nil
        cancellables = nil
        super.tearDown()
    }

    func test_givenSuccessResponse_whenFetchArticles_shouldUpdateArticlesAndImages() {
        // Given
        let expectation = self.expectation(description: "Expect to fetch articles successfully")
        let expectedTitle = "Test Article"
        let expectedImageUrlString = "http://example.com/image.png"
        let expectedArticles = [Article.stub(title: expectedTitle, urlToImage: expectedImageUrlString)]
        let response = ArticlesResponseFactory.makeResponse(articles: expectedArticles)

        mockAPIManager.expectedResponse = .success(response)

        var fetchedArticles: [Article] = []

        // When
        sut.$state
            .dropFirst()
            .sink(receiveValue: { state in
                switch state {
                case .loaded(let articles):
                    fetchedArticles = articles
                    expectation.fulfill()
                default:
                    break
                }
            })
            .store(in: &cancellables)

        sut.fetchArticles()

        // Then
        waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(fetchedArticles.count, 1, "Should have received one article.")
            XCTAssertEqual(fetchedArticles.first?.title, expectedTitle, "Article title should match.")
        }
    }

    func test_givenErrorResponse_whenFetchArticles_shouldSetHasError() {
        // Given
        let expectation = self.expectation(description: "Expect fetch to fail")
        mockAPIManager.expectedResponse = .failure(APIError.invalidResponse)

        var hasErrorOccurred = false

        // When
        sut.$state
            .dropFirst()
            .sink(receiveValue: { state in
                if case .error = state {
                    hasErrorOccurred = true
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)

        sut.fetchArticles()

        // Then
        waitForExpectations(timeout: 1) { error in
            XCTAssertTrue(hasErrorOccurred, "Should have set state to error due to API failure.")
        }
    }
}
