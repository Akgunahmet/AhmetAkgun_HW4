//
//  MockHomeRouter.swift
//  iTunesMusicTests
//
//  Created by Ahmet Akgün on 14.06.2023.
//

import Foundation
@testable import iTunesMusic

final class MockHomeRouter: HomeRouterProtocol {
  
    var isInvokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (route: HomeRoutes, Void)?
    
    func navigate(_ route: iTunesMusic.HomeRoutes) {
        isInvokedNavigate = true
        invokedNavigateCount += 1
        invokedNavigateParameters = (route, ())
    }
    
}
