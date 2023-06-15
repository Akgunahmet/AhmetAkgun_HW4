//
//  MockHomeInteractor.swift
//  iTunesMusicTests
//
//  Created by Ahmet Akgün on 14.06.2023.
//

import Foundation
@testable import iTunesMusic


final class MockHomeInteractor: HomeInteractorProtocol {
    
    var isInvokedFetchSongs = false
    var inkovedFetchSongsCount = 0
    
    func fetchSearchSongs(_ word: String) {
        isInvokedFetchSongs = true
       inkovedFetchSongsCount += 1

    }
}
