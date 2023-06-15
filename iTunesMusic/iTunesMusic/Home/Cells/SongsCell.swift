//
//  SongsCell.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//

import UIKit

// MARK: - Protocol

protocol SongsCellProtocol: AnyObject {
    func setImage(_ image: UIImage)
    func setTrackName(_ text: String)
    func setArtistName(_ text: String)
    func setCollectionName(_ text: String)
    func setButtonImage(_ image: UIImage?)
}

final class SongsCell: UITableViewCell {
    
// MARK: - Outlet
    
    @IBOutlet weak var artWorkURLImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var cellPresenter: SongsCellPresenterProtocol! {
        
    didSet {
            cellPresenter.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform.identity
        }
    }

// MARK: - Action
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        cellPresenter.togglePlayback()
    
    }
}

extension SongsCell: SongsCellProtocol {
    
// MARK: - Function
    
    func setTrackName(_ text: String) {
        trackName.text = text
    }
    
    func setArtistName(_ text: String) {
        artistName.text = text
    }
    
    func setCollectionName(_ text: String) {
        collectionName.text = text
    }
    
    func setImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.artWorkURLImage.image = image
        }
    }
    
    func setButtonImage(_ image: UIImage?) {
        playButton.setImage(image, for: .normal)
    }
}


