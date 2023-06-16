//
//  SongsCellPresenter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//


import Foundation
import iTunesMusicAPI
import SDWebImage
import AVFoundation

// MARK: - Protocol

protocol SongsCellPresenterProtocol: AnyObject {
    func load()
    func togglePlayback()
    func pause()
    static func stopCurrentPlayback()
}

final class SongsCellPresenter {
    
    private let songs: Results
    private let artworkURL: String
    private var audioPlayer: AVPlayer?
    private var isPlaying = false
    static var currentPlayingCell: SongsCell?
    weak var view: SongsCellProtocol?
    
    init(
        view: SongsCellProtocol?,
        songs: Results
    ){
        self.view = view
        self.songs = songs
        self.artworkURL = songs.artworkUrl100 ?? ""
    }
}

extension SongsCellPresenter: SongsCellPresenterProtocol {
    
// MARK: - Function
    
    static func stopCurrentPlayback() {
        currentPlayingCell?.cellPresenter.pause()
        currentPlayingCell = nil
    }
    
    func load() {
        if isPlaying {
            pause()
        }
        
        if let url = URL(string: artworkURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] (image, _, error, _, _, _) in
                if let error = error {
                    print("Image download error: \(error.localizedDescription)")
                } else if let image = image {
                    self?.view?.setImage(image)
                }
            }
        }

        view?.setTrackName(songs.trackName ?? "")
        view?.setArtistName(songs.artistName ?? "")
        view?.setCollectionName("Collection: \(String(describing: songs.collectionName ?? ""))")
        updateButtonImage()
        
    }
    
    func togglePlayback() {
        if let currentPlayingCell = SongsCellPresenter.currentPlayingCell {
           
            if currentPlayingCell != view as? SongsCell {
                currentPlayingCell.cellPresenter.pause()
            }
        }
        
        if isPlaying {
            pause()
        } else {
            play()
        }
        
        SongsCellPresenter.currentPlayingCell = view as? SongsCell
        updateButtonImage()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        DispatchQueue.main.async { [weak self] in
            self?.view?.setButtonImage(UIImage(named: "play"))
        }
    }
    
// MARK: - Private Function
    
    private func play() {
        guard let previewURLString = songs.previewUrl,
              let previewURL = URL(string: previewURLString) else {
            return
        }
        
        if audioPlayer == nil {
            let playerItem = AVPlayerItem(url: previewURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
        }
        
        audioPlayer?.play()
        isPlaying = true
    }
    
    private func updateButtonImage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if self.isPlaying {
                self.view?.setButtonImage(UIImage(named: "pause"))
            } else {
                self.view?.setButtonImage(UIImage(named: "play"))
            }
        }
    }
}
