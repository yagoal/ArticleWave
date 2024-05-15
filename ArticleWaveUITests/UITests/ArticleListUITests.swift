//
//  ArticleWaveUITests.swift
//  ArticleWaveUITests
//
//  Created by Yago Pereira on 11/5/24.
//

import XCTest

final class ArticleListUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    // MARK: - First Test
    func test01_articleListLoadingBehavior() throws {
        app.setLaunchArgument([.uiTest, .useMockHttpRequestWithDelay])
        app.launch()

        waitForLoadingToFinish()
        checkArticlesTable()
    }

    private func waitForLoadingToFinish() {
        let activityIndicator = app.activityIndicators["activityIndicator"]

        // Wait for the activity indicator to no longer be hittable, indicating that loading has finished
        expectation(
            for: NSPredicate(format: "isHittable == false"),
            evaluatedWith: activityIndicator,
            handler: nil
        )

        waitForExpectations(timeout: 5)

        XCTAssertFalse(
            activityIndicator.isHittable,
            "The activity indicator should not be hittable after loading."
        )
    }

    private func checkArticlesTable() {
        // Check that the articles table contains at least one article
        let articlesTable = app.tables["articlesTableView"]
        XCTAssertGreaterThanOrEqual(
            articlesTable.cells.count,
            10,
            "The table should contain at least 10 articles."
        )
    }

    // MARK: - Second Test
    func test02_headerCountrySelection() {
        app.setLaunchArgument([.uiTest])
        app.launch()
        checkTitleVisibility()
        checkCountryButtonsPresence()
    }

    private func checkTitleVisibility() {
        let titleLabel = app.staticTexts["newsTitleIdentifier"]
        XCTAssertTrue(
            titleLabel.exists,
            "The news title should be visible on the header."
        )
        XCTAssertEqual(
            titleLabel.label,
            "Notícias",
            "The news title label should display the correct title."
        )
    }

    private func checkCountryButtonsPresence() {
        let countries = ["br", "pt", "ar", "us", "gb"]
        for countryCode in countries {
            let countryButton = app.buttons["countryButton_\(countryCode)"]
            XCTAssertTrue(
                countryButton.exists,
                "The button for \(countryCode.uppercased()) should exist."
            )
        }
    }
}

