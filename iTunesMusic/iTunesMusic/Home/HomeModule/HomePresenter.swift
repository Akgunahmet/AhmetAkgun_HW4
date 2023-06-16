//
//  HomePresenter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import Foundation
import iTunesMusicAPI

// MARK: - Protocol

protocol HomePresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func song(_ index: Int) -> Results?
    func fetchSongs(_ word: String)
    func didSelectRowAt(index: Int)
    var numberOfItems: Int { get }
    var songs: [ Results] { get set }
    
}

class HomePresenter {
    
    unowned var view: HomeViewControllerProtocol
    var songs: [Results] = []
    var interactor: HomeInteractorProtocol!
    let router: HomeRouterProtocol!
    
    init(
        view: HomeViewControllerProtocol,
        router: HomeRouterProtocol,
        interactor: HomeInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    
    // MARK: - Function
    
    func viewDidLoad() {
        view.setupTableView()
        view.setTitle("iTunes")
    }
    
    func didSelectRowAt(index: Int) {
        guard let source = song(index) else { return }
        router.navigate(.detail(source: source))
    }
    
    func fetchSongs(_ word: String) {
        view.showLoadingView()
        interactor.fetchSearchSongs(word)
    }
    
    func song(_ index: Int) -> Results? {
        return songs[safe: index]
    }
    
    var numberOfItems: Int {
        songs.count
    }
}
// MARK: - Extension HomeInterOutput

extension HomePresenter: HomeInteractorOutput {
    
    func fetchSongsOutput(_ result: SongsSourcesResult) {
        view.hideLoadingView()
        switch result {
        case .success(let songs):
            self.songs = songs
            view.reloadData()
            if songs.isEmpty {
                view.showAlert(title: "Sonuç bulunamadı")
            }
        case .failure(let error):
            
            view.showError(error.localizedDescription)
            
        }
    }
}
