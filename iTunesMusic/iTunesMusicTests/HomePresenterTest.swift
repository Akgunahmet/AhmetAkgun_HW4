//
//  MockHomePresenterTest.swift
//  iTunesMusicTests
//
//  Created by Ahmet Akgün on 14.06.2023.
//

import XCTest
@testable import iTunesMusic
@testable import iTunesMusicAPI

final class HomePresenterTests: XCTestCase {
    
    var presenter: HomePresenter!
    var view: MockHomeViewController!
    var interactor: MockHomeInteractor!
    var router: MockHomeRouter!
    
    override func setUp() {
        super.setUp()
        
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
        
    }
    
    override func tearDown() {
        view = nil
        interactor = nil
        router = nil
        presenter = nil
    }
    
    func test_viewDidLoad_InvokesRequiredViewMoethods() {
        
        XCTAssertFalse(view.isInvokedSetupTableView)
        XCTAssertEqual(view.invokedSetupTableViewCount, 0)
        XCTAssertFalse(view.isInvokedSetTitle)
        XCTAssertNil(view.invokedSetTitleParameters)
        
        presenter.viewDidLoad()
        presenter.didSelectRowAt(index: 0)
        
        XCTAssertTrue(view.isInvokedSetupTableView)
        XCTAssertEqual(view.invokedSetupTableViewCount, 1)
        XCTAssertTrue(view.isInvokedSetTitle)
        XCTAssertEqual(view.invokedSetTitleParameters?.title, "iTunes")
        
    }
    
    func test_fetchSongsOutput() {
        
        XCTAssertFalse(view.isInvokedHideLoading)
        XCTAssertEqual(presenter.numberOfItems, 0)
        XCTAssertFalse(view.isInvokedReloadData)
        
        let results: [Results] = []
        presenter.fetchSongsOutput(.success(results))
        
        XCTAssertTrue(view.isInvokedHideLoading)
        XCTAssertEqual(presenter.numberOfItems, 0)
        XCTAssertTrue(view.isInvokedReloadData)
        
    }
    
    func test_fetchSongs() {
        
        XCTAssertFalse(interactor.isInvokedFetchSongs)
        XCTAssertEqual(interactor.inkovedFetchSongsCount, 0)
        
        presenter.fetchSongs("Tarkan")
        
        XCTAssertTrue(interactor.isInvokedFetchSongs)
        XCTAssertEqual(interactor.inkovedFetchSongsCount, 1)
        
    }
}


