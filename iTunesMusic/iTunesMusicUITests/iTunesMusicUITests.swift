//
//  iTunesMusicUITests.swift
//  iTunesMusicUITests
//
//  Created by Ahmet Akgün on 5.06.2023.
//

import XCTest

class HomeViewControllerUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("******** UITest ********")
    }

    func testSearchBarAndTableView() {

        app.launch()

        XCTAssertTrue(app.isSearchBarDisplayed)
        XCTAssertTrue(app.isTableViewDisplayed)

        app.searchBar.tap()
        app.searchBar.typeText("Tarkan")
        app.keyboards.buttons["Search"].tap()

        let tableCells = app.tableView.cells.element(boundBy: 1)

        tableCells.tap()
        sleep(5)

        XCTAssertTrue(app.isplayButtonDisplayed)

        app.detailPlayButton.tap()
        sleep(5)
        app.detailPlayButton.tap()
        sleep(2)
    }

}
extension XCUIApplication {
    var searchBar: XCUIElement! {
        searchFields["searchBar"]
    }

    var tableView: XCUIElement! {
        tables["tableView"]
    }
    var detailPlayButton: XCUIElement! {
        buttons["detailPlayButton"]
    }


    var isSearchBarDisplayed: Bool {
        return searchBar.waitForExistence(timeout: 5)
    }

    var isTableViewDisplayed: Bool {
        return tableView.waitForExistence(timeout: 5)
    }
    
    
    var isplayButtonDisplayed: Bool {
        return detailPlayButton.exists
    }
}

