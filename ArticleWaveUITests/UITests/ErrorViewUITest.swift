//
//  ErrorViewUITest.swift
//  ArticleWaveUITests
//
//  Created by Yago Pereira on 13/5/24.
//

import XCTest

final class ErrorViewUITest: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    func testErrorViewAppearanceAndInteractions() {
        // Launch the app with a condition that triggers the error state
        app.setLaunchArgument([.uiTest, .useMockHttpRequestsWithError])
        app.launch()

        // Check if the error view elements exist
        let errorImageView = app.images["errorImageView"]
        XCTAssertTrue(errorImageView.exists, "Error image should be displayed on error.")

        let errorTitleLabel = app.staticTexts["errorTitleLabel"]
        XCTAssertTrue(errorTitleLabel.exists, "Error title label should be displayed on error.")
        XCTAssertEqual(errorTitleLabel.label, "Ocorreu um Erro", "Error title label text is incorrect.")

        let errorSubtitleLabel = app.staticTexts["errorSubtitleLabel"]
        XCTAssertTrue(errorSubtitleLabel.exists, "Error subtitle label should be displayed on error.")
        XCTAssertEqual(errorSubtitleLabel.label, "Não foi possível completar sua solicitação.", "Error subtitle label text is incorrect.")

        let retryButton = app.buttons["errorRetryButton"]
        XCTAssertTrue(retryButton.exists, "Retry button should be displayed on error.")
    }
}
