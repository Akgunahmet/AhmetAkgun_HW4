//
//  DetailsViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import UIKit
import iTunesMusicAPI

class DetailsViewController: UIViewController {
  
    @IBOutlet weak var name: UILabel!
//    let service: iTunesMusicServiceProtocol = iTunesMusicService()
//    private var songs: [Song] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       // searchSong("al aramızdan")
        // Do any additional setup after loading the view.
    }

//    func searchSong(_ word: String) {
//        service.searchSong(word) { [weak self] result in
//            switch result {
//            case .success(let songData):
//                DispatchQueue.main.async {
//                    self?.songs = [songData]
//                    self?.name.text = songData.results?.first?.artistName
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }


}

