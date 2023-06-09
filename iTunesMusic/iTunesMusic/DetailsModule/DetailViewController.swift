//
//  DetailViewController.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//

import UIKit

// MARK: - Protocol

protocol DetailViewControllerProtocol: AnyObject {
    func setArtistImage(_ image: UIImage)
    func setArtistName(_ text: String)
    func setCollection(_ text: String)
    func setTrackName(_ text: String)
    func setKind(_ text: String)
    func setTrackPrice(_ text: Double)
    func setCollectionPrice(_ text: Double)
    func setButtonImage(_ image: UIImage?)
    func setPlaybackProgress(_ progress: Float)
    func setFavoriteButtonImage(isFavorite: Bool)
}

class DetailViewController: UIViewController {
    
// MARK: - Outlet
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblCollection: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblKind: UILabel!
    @IBOutlet weak var lblTrackPrice: UILabel!
    @IBOutlet weak var lblCollectionPrice: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        presenter.resetPlaybackProgress()
        
    }
    
// MARK: - Action
    
    @IBAction func playButtonClicked(_ sender: Any) {
        presenter.togglePlayPause()
    }
    
    @IBAction func favoriteClickedButton(_ sender: Any) {
        let artistName = lblArtistName.text ?? ""
          let collectionName = lblCollection.text ?? ""
          let trackName = lblTrackName.text ?? ""
          
          if presenter.isFavorite {
              presenter.deleteFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
          } else {
              presenter.saveFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
          }
    }

  
}
// MARK: - Extension

extension DetailViewController: DetailViewControllerProtocol {
    func setFavoriteButtonImage(isFavorite: Bool) {
        let buttonImage = isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        favoriteButton.setImage(buttonImage, for: .normal)
        
    }
   
// MARK: - Function
    
    func setPlaybackProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressView.progress = progress
        }
    }
    
    func setArtistImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.artistImage.image = image
        }
    }
    
    func setArtistName(_ text: String) {
        self.lblArtistName.text = text
    }
    
    func setCollection(_ text: String) {
        self.lblCollection.text = text
    }
    
    func setTrackName(_ text: String) {
        self.lblTrackName.text = text
    }
    
    func setKind(_ text: String) {
        self.lblKind.text = text
    }
    
    func setTrackPrice(_ text: Double) {
        let formattedPrice = String(format: "%.2f", text)
        self.lblTrackPrice.text = "Track Price: \(formattedPrice)$"
    }
    
    func setCollectionPrice(_ text: Double) {
        let formattedPrice = String(format: "%.2f", text)
        self.lblCollectionPrice.text = "Collection Price: \(formattedPrice)$"
    }
    func setButtonImage(_ image: UIImage?) {
        playButton.setImage(image, for: .normal)
    }
    
}


//import UIKit
//
//// MARK: - Protocol
//
//protocol DetailViewControllerProtocol: AnyObject {
//    func setArtistImage(_ image: UIImage)
//    func setArtistName(_ text: String)
//    func setCollection(_ text: String)
//    func setTrackName(_ text: String)
//    func setKind(_ text: String)
//    func setTrackPrice(_ text: Double)
//    func setCollectionPrice(_ text: Double)
//    func setButtonImage(_ image: UIImage?)
//    func setPlaybackProgress(_ progress: Float)
//    func setFavoriteButtonImage(isFavorite: Bool)
//}
//
//class DetailViewController: UIViewController {
//
//// MARK: - Outlet
//
//    @IBOutlet weak var artistImage: UIImageView!
//    @IBOutlet weak var lblArtistName: UILabel!
//    @IBOutlet weak var lblCollection: UILabel!
//    @IBOutlet weak var lblTrackName: UILabel!
//    @IBOutlet weak var lblKind: UILabel!
//    @IBOutlet weak var lblTrackPrice: UILabel!
//    @IBOutlet weak var lblCollectionPrice: UILabel!
//    @IBOutlet weak var playButton: UIButton!
//    @IBOutlet weak var progressView: UIProgressView!
//    @IBOutlet weak var favoriteButton: UIButton!
//
//    var presenter: DetailPresenterProtocol!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        presenter.viewDidLoad()
//        presenter.resetPlaybackProgress()
//
//    }
//
//// MARK: - Action
//
//    @IBAction func playButtonClicked(_ sender: Any) {
//        presenter.togglePlayPause()
//    }
//
//    @IBAction func favoriteClickedButton(_ sender: Any) {
//        let artistName = lblArtistName.text ?? ""
//           let collectionName = lblCollection.text ?? ""
//           let trackName = lblTrackName.text ?? ""
//
//           presenter.saveFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
//
//    }
//
//
//}
//// MARK: - Extension
//
//extension DetailViewController: DetailViewControllerProtocol {
//    func setFavoriteButtonImage(isFavorite: Bool) {
//        let buttonImage = isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
//        favoriteButton.setImage(buttonImage, for: .normal)
//
//    }
//
//// MARK: - Function
//
//    func setPlaybackProgress(_ progress: Float) {
//        DispatchQueue.main.async {
//            self.progressView.progress = progress
//        }
//    }
//
//    func setArtistImage(_ image: UIImage) {
//        DispatchQueue.main.async {
//            self.artistImage.image = image
//        }
//    }
//
//    func setArtistName(_ text: String) {
//        self.lblArtistName.text = text
//    }
//
//    func setCollection(_ text: String) {
//        self.lblCollection.text = text
//    }
//
//    func setTrackName(_ text: String) {
//        self.lblTrackName.text = text
//    }
//
//    func setKind(_ text: String) {
//        self.lblKind.text = text
//    }
//
//    func setTrackPrice(_ text: Double) {
//        let formattedPrice = String(format: "%.2f", text)
//        self.lblTrackPrice.text = "Track Price: \(formattedPrice)$"
//    }
//
//    func setCollectionPrice(_ text: Double) {
//        let formattedPrice = String(format: "%.2f", text)
//        self.lblCollectionPrice.text = "Collection Price: \(formattedPrice)$"
//    }
//    func setButtonImage(_ image: UIImage?) {
//        playButton.setImage(image, for: .normal)
//    }
//
//}
