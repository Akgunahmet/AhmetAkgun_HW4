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
    func showAlert(title: String, message: String)
    
}

class DetailViewController: UIViewController {
    
// MARK: - Outlet
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var primaryGenreNameLabel: UILabel!
    @IBOutlet weak var trackPriceLabel: UILabel!
    @IBOutlet weak var collectionPriceLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var favoriteButton: UIButton!


    
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.accessibilityIdentifier = "detailPlayButton"
        favoriteButton.accessibilityIdentifier = "detailFavoriteButton"
        presenter.viewDidLoad()
        presenter.resetPlaybackProgress()
        
    }
    
// MARK: - Action
    
    @IBAction func showFavoriteArtist(_ sender: Any) {

        presenter.showFavoriteArtistsPopUp { artistInfoList in
            // Pop-up ekranınızı oluşturun ve verileri ekleyin
            let popupViewController = UIAlertController(title: "Favorite Artists", message: nil, preferredStyle: .alert)

            // Arka plan rengini gri yapma
            let subview = (popupViewController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.backgroundColor = UIColor.darkGray

            // Yazıları beyaz yapma
            let attributedTitle = NSAttributedString(string: "Favorite Artists", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            popupViewController.setValue(attributedTitle, forKey: "attributedTitle")

            for artistInfo in artistInfoList {
                // Liste elemanlarının yazılarını beyaz yapma
                let artistAction = UIAlertAction(title: artistInfo, style: .default, handler: nil)
                artistAction.setValue(UIColor.white, forKey: "titleTextColor")

                popupViewController.addAction(artistAction)
            }

            // Kapatma işlemi için bir düğme ekle
            let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            closeAction.setValue(UIColor.white, forKey: "titleTextColor")
            popupViewController.addAction(closeAction)

            // Pop-up ekranını göster
            self.present(popupViewController, animated: true, completion: nil)
        }

    }

    @IBAction func playButtonClicked(_ sender: Any) {
        presenter.togglePlayPause()
    }
    
    @IBAction func skipForwardButtonClicked(_ sender: Any) {
          presenter.skipForward()
      }
      
      @IBAction func skipBackwardButtonClicked(_ sender: Any) {
          presenter.skipBackward()
      }
    
    @IBAction func favoriteClickedButton(_ sender: Any) {
        let artistName = artistNameLabel.text ?? ""
          let collectionName = collectionNameLabel.text ?? ""
          let trackName = trackNameLabel.text ?? ""
          
          if presenter.isFavorite {
              presenter.deleteFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
          } else {
              presenter.saveFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
          }
    }
}
// MARK: - Extension

extension DetailViewController: DetailViewControllerProtocol {
    func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
     }
    
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
        self.artistNameLabel.text = text
    }
    
    func setCollection(_ text: String) {
        self.collectionNameLabel.text = text
    }
    
    func setTrackName(_ text: String) {
        self.trackNameLabel.text = text
    }
    
    func setKind(_ text: String) {
        self.primaryGenreNameLabel.text = text
    }
    
    func setTrackPrice(_ text: Double) {
        let formattedPrice = String(format: "%.2f", text)
        self.trackPriceLabel.text = "Track Price: \(formattedPrice)$"
    }
    
    func setCollectionPrice(_ text: Double) {
        let formattedPrice = String(format: "%.2f", text)
        self.collectionPriceLabel.text = "Collection Price: \(formattedPrice)$"
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
//          let collectionName = lblCollection.text ?? ""
//          let trackName = lblTrackName.text ?? ""
//
//          if presenter.isFavorite {
//              presenter.deleteFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
//          } else {
//              presenter.saveFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
//          }
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
//
