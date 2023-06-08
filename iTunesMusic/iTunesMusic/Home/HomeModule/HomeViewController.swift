//
//  HomeViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//

import UIKit


protocol HomeViewControllerProtocol: AnyObject {
    func setupTableView()
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
    func showError(_ message: String)
}

class HomeViewController: BaseViewController  {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: HomePresenterProtocol!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    
        
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: SongsCell.self)
    }
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
    
        }
    }
    
    func showError(_ message: String) {
        showAlert("Error", message)
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()

    }
    
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SongsCell.self, for: indexPath)
        cell.selectionStyle = .none
        
        if let songs = presenter?.song(indexPath.row) {
            cell.cellPresenter = SongsCellPresenter(view: cell, songs: songs)
        }
        return cell
    }
  
}
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SongsCellPresenter.stopCurrentPlayback()
        presenter.didSelectRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchTerm = searchBar.text?.removingTurkishDiacritics().uppercased() {
            presenter?.fetchSongs(searchTerm)
        }

        searchBar.resignFirstResponder()
    }
}
extension String {
    func removingTurkishDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}

//
//import UIKit
//
//
//protocol HomeViewControllerProtocol: AnyObject {
//    func setupTableView()
//    func reloadData()
//    func showLoadingView()
//    func hideLoadingView()
//    func showError(_ message: String)
//}
//
//class HomeViewController: BaseViewController  {
//    @IBOutlet weak var tableView: UITableView!
//    
//    var presenter: HomePresenterProtocol!
// 
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        presenter?.viewDidLoad()
//    
//        
//    }
//}
//
//extension HomeViewController: HomeViewControllerProtocol {
//    func setupTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(cellType: SongsCell.self)
//    }
//    func reloadData() {
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
//            self.tableView.reloadData()
//    
//        }
//    }
//    
//    func showError(_ message: String) {
//        showAlert("Error", message)
//    }
//    
//    func showLoadingView() {
//        showLoading()
//    }
//    
//    func hideLoadingView() {
//        hideLoading()
//
//    }
//    
//}
//extension HomeViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter?.numberOfItems ?? 0
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(with: SongsCell.self, for: indexPath)
//        cell.selectionStyle = .none
//        
//        if let songs = presenter?.song(indexPath.row) {
//            cell.cellPresenter = SongsCellPresenter(view: cell, songs: songs)
//        }
//        return cell
//    }
//  
//}
//extension HomeViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        SongsCellPresenter.stopCurrentPlayback()
//        presenter.didSelectRowAt(index: indexPath.row)
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130
//    }
//    
//}
//
//extension HomeViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        if let searchTerm = searchBar.text?.removingTurkishDiacritics().uppercased() {
//            presenter?.fetchSongs(searchTerm)
//        }
//
//        searchBar.resignFirstResponder()
//    }
//}
//extension String {
//    func removingTurkishDiacritics() -> String {
//        return self.folding(options: .diacriticInsensitive, locale: .current)
//    }
//}
