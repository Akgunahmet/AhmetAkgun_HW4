//
//  DetailsPresenter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import Foundation
import iTunesMusicAPI
import SDWebImage
import AVFoundation


// MARK: - Protocol

protocol DetailPresenterProtocol {
    
    func viewDidLoad()
    func getSource() -> Results?
    func togglePlayPause()
    func resetPlaybackProgress()
    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String)
    func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String)
    func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool
    func showFavoriteArtistsPopUp(completion: @escaping ([String]) -> Void)
    func skipForward()
    func skipBackward()
    var isFavorite: Bool { get set }
    var source: Results? { get set }
}

final class DetailPresenter {
    
    private var artworkURL: String?
    private var audioPlayer: AVPlayer?
    private var isPlaying = false
    private var playbackProgressObserver: Any?
    unowned var view: DetailViewControllerProtocol!
    var source: Results?
    let router: DetailRouterProtocol!
    var interactor: DetailInteractorProtocol!
    var isFavorite = false {
        didSet {
            view.setFavoriteButtonImage(isFavorite: isFavorite)
        }
    }
  
    // MARK: - Initialize
    
    init(
        view: DetailViewControllerProtocol,
        router: DetailRouterProtocol,
        interactor: DetailInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
}
// MARK: - Extension

extension DetailPresenter: DetailPresenterProtocol {
    
    func showFavoriteArtistsPopUp(completion: @escaping ([String]) -> Void) {
        interactor.showFavoriteArtist(completion: completion)
    }
    
    // MARK: - Function
    
    func viewDidLoad() {
        
        guard let details = getSource() else { return }
        updateArtworkURL()

        if let artworkURL = artworkURL, let _ = URL(string: artworkURL) {
            let modifiedURLString = artworkURL.replacingOccurrences(of: "/100x100bb.jpg", with: "/640x640bb.jpg")
            if let modifiedURL = URL(string: modifiedURLString) {
                SDWebImageManager.shared.loadImage(with: modifiedURL, options: .continueInBackground, progress: nil) { [weak self] (image, _, error, _, _, _) in
                    if let error = error {
                        print("Image download error: \(error.localizedDescription)")
                    } else if let image = image {
                        self?.view?.setArtistImage(image)
                    }
                }
            }
        }
        
        view.setArtistName(details.artistName ?? "")
        view.setCollection(details.collectionName ?? "")
        view.setTrackName(details.trackName ?? "")
        view.setKind(details.primaryGenreName ?? "")
        view.setTrackPrice(details.trackPrice ?? 0)
        view.setCollectionPrice(details.collectionPrice ?? 0)
        
        let artistName = details.artistName ?? ""
        let collectionName = details.collectionName ?? ""
        let trackName = details.trackName ?? ""
        isFavorite = isFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
        view.setFavoriteButtonImage(isFavorite: isFavorite)
        updateButtonImage()
        
    }
    
    func getSource() -> Results? {
        return source
    }
    
    private func updateArtworkURL() {
        artworkURL = source?.artworkUrl100 ?? ""
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    private func play() {
        guard let previewURLString = source?.previewUrl,
              let previewURL = URL(string: previewURLString) else {
            return
        }
        
        if audioPlayer == nil {
            let playerItem = AVPlayerItem(url: previewURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            addPlaybackProgressObserver()
            audioPlayer?.play() // Ses çalmasını burada başlatıyoruz
        } else {
            addPlaybackProgressObserver()
            audioPlayer?.play()
        }
        
        isPlaying = true
        updateButtonImage()
    }
    
    private func pause() {
        audioPlayer?.pause()
        isPlaying = false
        removePlaybackProgressObserver()
        DispatchQueue.main.async { [weak self] in
            self?.view?.setButtonImage(UIImage(named: "playy-2"))
        }
    }
    
    func resetPlaybackProgress() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setPlaybackProgress(0.0)
            self?.audioPlayer?.seek(to: .zero) // Şarkıyı başa sar
        }
    }
    
    private func updatePlaybackProgress() {
        guard let player = audioPlayer else { return }
        let currentTime = Float(player.currentTime().seconds)
        let duration = Float(player.currentItem?.duration.seconds ?? 0)
        let progress = currentTime / duration
        view?.setPlaybackProgress(progress)
    }

    private func addPlaybackProgressObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        playbackProgressObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let duration = self?.audioPlayer?.currentItem?.duration.seconds else { return }
            let progress = Float(time.seconds / duration)
            self?.view?.setPlaybackProgress(progress)
            
            if progress >= 1.0 {
                self?.audioPlayer?.pause()
                self?.isPlaying = false
                self?.removePlaybackProgressObserver()
                self?.updateButtonImage()
                self?.resetPlaybackProgress()
            }
        }
    }

    private func removePlaybackProgressObserver() {
        if let observer = playbackProgressObserver {
            audioPlayer?.removeTimeObserver(observer)
            playbackProgressObserver = nil
        }
    }
    
    private func updateButtonImage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.isPlaying {
                self.view?.setButtonImage(UIImage(named: "pausee-2"))
            } else {
                self.view?.setButtonImage(UIImage(named: "playy-2"))
            }
            if !self.isPlaying {
                self.view?.setPlaybackProgress(0.0)
            }
        }
    }
    
     func skipForward() {
          guard let player = audioPlayer else { return }
          let currentTime = player.currentTime().seconds
          let newTime = currentTime + 5.0
          let timeToSeek = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
          player.seek(to: timeToSeek)
      }
      
      func skipBackward() {
          guard let player = audioPlayer else { return }
          let currentTime = player.currentTime().seconds
          let newTime = currentTime - 5.0
          let timeToSeek = CMTime(seconds: newTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
          player.seek(to: timeToSeek)
      }
    
    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
        interactor.saveFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
        isFavorite = true
        view.setFavoriteButtonImage(isFavorite: true)
        view.showAlert(title: "", message: "Are you sure you want to add to favorites?")
    }
    
    func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
        interactor.deleteFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
        isFavorite = false
        view.setFavoriteButtonImage(isFavorite: false)
        view.showAlert(title: "", message: "Are you sure you want to remove from favorites?")
    }
    
    func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool {
        interactor.isFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
    }
    
}
