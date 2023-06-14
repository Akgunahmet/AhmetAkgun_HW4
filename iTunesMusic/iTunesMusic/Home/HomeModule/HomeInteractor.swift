//
//  HomeInteractor.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//
import Foundation
import iTunesMusicAPI

typealias SongsSourcesResult = Result<[Results], Error>

protocol HomeInteractorProtocol: AnyObject {
    func fetchSearchSongs(_ word: String)
}

protocol HomeInteractorOutput: AnyObject {
   
    func fetchSongsOutput(_ result: SongsSourcesResult)
}

var service: iTunesMusicServiceProtocol = iTunesMusicService()

class HomeInteractor {
    weak var output: HomeInteractorOutput?
   
}

extension HomeInteractor: HomeInteractorProtocol {
    
// MARK: - Function
    
    func fetchSearchSongs(_ word: String) {
        service.searchSongs(word) { [weak self] result in
            guard let self else { return }
            self.output?.fetchSongsOutput(result)
            
        }
    }
}

