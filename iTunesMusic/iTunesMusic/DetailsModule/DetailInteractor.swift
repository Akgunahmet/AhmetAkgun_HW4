//
//  DetailsInteractor.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import Foundation
import iTunesMusicAPI

protocol DetailInteractorProtocol {
    
}

protocol DetailInteractorOutputProtocol {
    func fetchNewsDetailOutput(_ result: Result<[Results], Error>)
}


final class DetailInteractor {
    var output: HomeInteractorOutput?
}
