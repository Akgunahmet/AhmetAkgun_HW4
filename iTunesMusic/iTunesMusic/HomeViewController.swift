//
//  ViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 5.06.2023.
//


import UIKit
import iTunesMusicAPI


class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let service: iTunesMusicServiceProtocol = iTunesMusicService()
    private var songs: [Results] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func searchSongs(_ word: String) {
            service.searchSongs(word) { [weak self] result in
                switch result {
                case .success(let songData):
                    DispatchQueue.main.async {
                        self?.songs = songData
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell

        let song = songs[indexPath.row]
        cell.configure(with: song)

        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text?.removingTurkishDiacritics().uppercased() {
                   searchSongs(searchTerm)
               }

               searchBar.resignFirstResponder()
           }
}
extension String {
    func removingTurkishDiacritics() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}


