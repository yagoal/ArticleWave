//
//  ArticleDetailsUITests.swift
//  ArticleWaveUITests
//
//  Created by Yago Pereira on 13/5/24.
//

import XCTest

final class ArticleDetailsUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    func testNavigationToArticleDetails() {
        app.setLaunchArgument([.uiTest])
        app.launch()
        let articlesTable = app.tables["articlesTableView"]
        XCTAssertTrue(articlesTable.exists, "Articles table should exist on launching the app with mocked data.")

        // Tap the first article cell
        let firstArticleCell = articlesTable.cells.element(boundBy: 0)
        if firstArticleCell.exists {
            firstArticleCell.tap()
        } else {
            XCTFail("First article cell does not exist or table is empty.")
        }

        // Verify elements in the detail view
        let scrollView = app.scrollViews["articleDetailsScrollView"]
        XCTAssertTrue(scrollView.exists, "ScrollView should be present on the article details screen.")

        let titleLabel = app.staticTexts["articleDetailsTitleLabel"]
        XCTAssertTrue(titleLabel.exists, "Title label should be visible.")

        let contentLabel = app.staticTexts["articleDetailsContentLabel"]
        XCTAssertTrue(contentLabel.exists, "Content label should be visible.")

        let goToSiteButton = app.buttons["articleDetailsGoToSiteButton"]
        XCTAssertTrue(goToSiteButton.exists, "Go to site button should be visible and accessible.")
    }
}
