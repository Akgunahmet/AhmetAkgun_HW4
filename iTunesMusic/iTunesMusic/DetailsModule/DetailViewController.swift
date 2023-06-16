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
    @IBOutlet weak var favoriteListButton: UIButton!
    
    private var favoriteBarButtonItem: UIBarButtonItem?
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccessiblityIdentifiers()
        presenter.viewDidLoad()
        presenter.resetPlaybackProgress()
        navigationController?.navigationBar.tintColor = UIColor.systemGray5
        setupFavoriteBarButtonItem()
        favoriteBarButtonItem?.isHidden = false
        favoriteBarButtonItem?.isEnabled = true
        setFavoriteButtonImage(isFavorite: presenter.isFavorite)
    }
    
    // MARK: - Action
    
    private func setAccessiblityIdentifiers() {
        playButton.accessibilityIdentifier = "detailPlayButton"
        favoriteListButton.accessibilityIdentifier = "detailFavoriteButton"
        
    }
    
    @objc private func favoriteButtonClicked() {
        let artistName = artistNameLabel.text ?? ""
        let collectionName = collectionNameLabel.text ?? ""
        let trackName = trackNameLabel.text ?? ""
        
        if presenter.isFavorite {
            presenter.deleteFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
        } else {
            presenter.saveFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
        }
    }
    
    @IBAction func showFavoriteArtist(_ sender: Any) {
        
        presenter.showFavoriteArtistsPopUp { artistInfoList in
            
            let popupViewController = UIAlertController(title: "Favorite Artists", message: nil, preferredStyle: .alert)
            
            let subview = (popupViewController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.backgroundColor = UIColor.darkGray
            
            let attributedTitle = NSAttributedString(string: "Favorite Artists", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            popupViewController.setValue(attributedTitle, forKey: "attributedTitle")
            
            for artistInfo in artistInfoList {
                
                let artistAction = UIAlertAction(title: artistInfo, style: .default, handler: nil)
                artistAction.setValue(UIColor.white, forKey: "titleTextColor")
                
                popupViewController.addAction(artistAction)
            }
            
            let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            closeAction.setValue(UIColor.white, forKey: "titleTextColor")
            popupViewController.addAction(closeAction)
            
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
    
}
// MARK: - Extension

extension DetailViewController: DetailViewControllerProtocol {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
  
    
    private func setupFavoriteBarButtonItem() {
        favoriteBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(favoriteButtonClicked))
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
    }
    func setFavoriteButtonImage(isFavorite: Bool) {
        let buttonImage = isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")

        favoriteBarButtonItem?.tintColor = UIColor(red: 225/255, green: 239/255, blue: 2/255, alpha: 1.0)
        favoriteBarButtonItem?.image = buttonImage
        
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
