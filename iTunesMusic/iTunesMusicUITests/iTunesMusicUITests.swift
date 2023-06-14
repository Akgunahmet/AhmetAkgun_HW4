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
        sleep(2)

        XCTAssertTrue(app.isFavoriteButtonDisplayed)
        XCTAssertTrue(app.isplayButtonDisplayed)

        app.detailPlayButton.tap()
        sleep(3)
        app.detailPlayButton.tap()
        app.detailFavoriteButton.tap()
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
    var detailFavoriteButton: XCUIElement! {
        buttons["detailFavoriteButton"]
    }

    var isSearchBarDisplayed: Bool {
        return searchBar.waitForExistence(timeout: 5)

    }

    var isTableViewDisplayed: Bool {
        return tableView.waitForExistence(timeout: 5)
    }
    var isFavoriteButtonDisplayed: Bool {
        return detailPlayButton.exists
    }
    var isplayButtonDisplayed: Bool {
        return detailPlayButton.exists
    }
}


//
//import XCTest
//
//final class iTunesMusicUITests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//
//}
//
