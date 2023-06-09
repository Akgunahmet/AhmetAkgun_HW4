//
//  SongsCellPresenter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//


import Foundation
import UIKit
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
            pause() // Stop the currently playing audio
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
        view?.setCollectionName(songs.collectionName ?? "")
        updateButtonImage()
        
    }
    
    func togglePlayback() {
        if let currentPlayingCell = SongsCellPresenter.currentPlayingCell {
            // Eğer başka bir hücrede ses çalınıyorsa, çalmayı durdur
            if currentPlayingCell != view as? SongsCell {
                currentPlayingCell.cellPresenter.pause()
            }
        }
        
        if isPlaying {
            pause()
        } else {
            play()
        }
        
        SongsCellPresenter.currentPlayingCell = view as? SongsCell // Şu anki hücreyi çalan hücre olarak belirle
        updateButtonImage()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        DispatchQueue.main.async { [weak self] in
            self?.view?.setButtonImage(UIImage(named: "playy-2"))
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
                self.view?.setButtonImage(UIImage(named: "pausee-2"))
            } else {
                self.view?.setButtonImage(UIImage(named: "playy-2"))
            }
        }
    }
}

//import Foundation
//import UIKit
//import iTunesMusicAPI
//import SDWebImage
//import AVFoundation
//
//
//protocol SongsCellPresenterProtocol: AnyObject {
//    func load()
//    func togglePlayback()
//    func pause()
//    static func stopCurrentPlayback()
//}
//
//final class SongsCellPresenter {
//
//    weak var view: SongsCellProtocol?
//    private let songs: Results
//    private let artworkURL: String
//    private var audioPlayer: AVPlayer?
//    private var isPlaying = false
//    static var currentPlayingCell: SongsCell?
//
//
//    init(
//        view: SongsCellProtocol?,
//         songs: Results
//    ){
//        self.view = view
//        self.songs = songs
//        self.artworkURL = songs.artworkUrl100 ?? ""
//    }
//}
//
//extension SongsCellPresenter: SongsCellPresenterProtocol {
//    static func stopCurrentPlayback() {
//        currentPlayingCell?.cellPresenter.pause()
//        currentPlayingCell = nil
//    }
//
//    func load() {
//        if isPlaying {
//                   pause() // Stop the currently playing audio
//               }
//
//        if let url = URL(string: artworkURL) {
//            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] (image, _, error, _, _, _) in
//                if let error = error {
//                    print("Image download error: \(error.localizedDescription)")
//                } else if let image = image {
//                    self?.view?.setImage(image)
//                }
//            }
//        }
//
//
//        view?.setTrackName(songs.trackName ?? "")
//        view?.setArtistName(songs.artistName ?? "")
//        view?.setCollectionName(songs.collectionName ?? "")
//        updateButtonImage()
//
//    }
//
//    func togglePlayback() {
//        if let currentPlayingCell = SongsCellPresenter.currentPlayingCell {
//            // Eğer başka bir hücrede ses çalınıyorsa, çalmayı durdur
//            if currentPlayingCell != view as? SongsCell {
//                currentPlayingCell.cellPresenter.pause()
//            }
//        }
//
//        if isPlaying {
//            pause()
//        } else {
//            play()
//        }
//
//        SongsCellPresenter.currentPlayingCell = view as? SongsCell // Şu anki hücreyi çalan hücre olarak belirle
//
//        updateButtonImage()
//    }
//        private func play() {
//            guard let previewURLString = songs.previewUrl,
//                let previewURL = URL(string: previewURLString) else {
//                    return
//            }
//
//            if audioPlayer == nil {
//                let playerItem = AVPlayerItem(url: previewURL)
//                audioPlayer = AVPlayer(playerItem: playerItem)
//            }
//
//            audioPlayer?.play()
//            isPlaying = true
//        }
//
//      func pause() {
//            audioPlayer?.pause()
//            isPlaying = false
//          DispatchQueue.main.async { [weak self] in
//                self?.view?.setButtonImage(UIImage(systemName: "play.circle"))
//            }
//        }
//
//        private func updateButtonImage() {
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                if self.isPlaying {
//                    self.view?.setButtonImage(UIImage(systemName: "pause.circle"))
//                } else {
//                    self.view?.setButtonImage(UIImage(systemName: "play.circle"))
//                }
//            }
//        }
//  }




