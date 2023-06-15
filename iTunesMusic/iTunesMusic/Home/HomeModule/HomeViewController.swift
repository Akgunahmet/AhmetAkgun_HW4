//
//  HomeViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//

import UIKit

// MARK: - Protocol

protocol HomeViewControllerProtocol: AnyObject {
    func setupTableView()
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
    func showError(_ message: String)
    func setTitle(_ title: String)
}

class HomeViewController: BaseViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var searchTimer: Timer?
    private let searchDelay: TimeInterval = 1.1
    var presenter: HomePresenterProtocol!
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        searchBarView()
        navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setAccessiblityIdentifiers()
        
    }
    
    func searchBarView() {
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.white
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
    }
    
    private func performSearch(with searchTerm: String) {
        let cleanedSearchTerm = searchTerm.removingTurkishDiacritics().uppercased()
        presenter?.fetchSongs(cleanedSearchTerm)
    }
    
    private func setAccessiblityIdentifiers() {
        searchBar.searchTextField.accessibilityIdentifier = "searchBar"
        tableView.accessibilityIdentifier = "tableView"
        
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    
    // MARK: - Function
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(cellType: SongsCell.self)
        backgroundText()
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
    
    func setTitle(_ title: String) {
        self.title = title
    }

    private func backgroundText() {
        let backgroundView = UIView(frame: tableView.bounds)

        let title = UILabel()
        title.text = "Uncover New Adventures"
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .lightGray

        let subtitle = UILabel()
        subtitle.text = "Music, Lyrics, and More"
        subtitle.textAlignment = .center
        subtitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitle.textColor = .white

        backgroundView.addSubview(title)
        backgroundView.addSubview(subtitle)

        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            subtitle.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8)
        ])

        tableView.backgroundView = backgroundView
        tableView.backgroundView?.isHidden = !isSearchBarEmpty
    }
}

// MARK: - TableView Extension

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

// MARK: - SearchBar Extension

extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         searchTimer?.invalidate()
         
         let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
         
         if !trimmedText.isEmpty {
             searchTimer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false) { [weak self] _ in
                 self?.performSearch(with: trimmedText)
             }
             tableView.backgroundView?.isHidden = true
         } else {
             // Search bar boş olduğunda sayfayı boş hale getir
             tableView.backgroundView?.isHidden = false
             presenter.songs.removeAll()
             tableView.reloadData()
         }
     }
 }


extension String {
    func removingTurkishDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}


