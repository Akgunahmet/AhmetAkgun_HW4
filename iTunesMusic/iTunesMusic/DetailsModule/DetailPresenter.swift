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
    var source: Results? { get set }
    func togglePlayPause()
    func resetPlaybackProgress()
    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String)
    func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String)
    func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool
    var isFavorite: Bool { get set }
   func showFavoriteArtistsPopUp(completion: @escaping ([String]) -> Void)

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

        if let artworkURL = artworkURL, let url = URL(string: artworkURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] (image, _, error, _, _, _) in
                if let error = error {
                    print("Image download error: \(error.localizedDescription)")
                } else if let image = image {
                    self?.view?.setArtistImage(image)
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

    }

    func getSource() -> Results? {
        return source
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func resetPlaybackProgress() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.setPlaybackProgress(0.0)
        }
    }

    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
        interactor.saveFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
        isFavorite = true
        view.setFavoriteButtonImage(isFavorite: true)
        view.showAlert(title: "", message: "Favorite artist saved.")
    }
    func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
        interactor.deleteFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
        isFavorite = false
        view.setFavoriteButtonImage(isFavorite: false)
        view.showAlert(title: "", message: "Removed from favorites.")
    }
    func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool {
        interactor.isFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
    }


// MARK: - Private Function

    private func updateArtworkURL() {
        artworkURL = source?.artworkUrl100 ?? ""
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

            // Duraklatıldığında ilerleme çubuğunun son konumuna güncellenmesi
            if progress >= 1.0 {
                self?.audioPlayer?.pause()
                self?.isPlaying = false
                self?.removePlaybackProgressObserver()
                self?.updateButtonImage()
            }
        }
    }

    private func removePlaybackProgressObserver() {
        if let observer = playbackProgressObserver {
            audioPlayer?.removeTimeObserver(observer)
            playbackProgressObserver = nil
        }
    }
}

//import Foundation
//import iTunesMusicAPI
//import SDWebImage
//import AVFoundation
//import CoreData
//
//// MARK: - Protocol
//
//protocol DetailPresenterProtocol {
//
//    func viewDidLoad()
//    func getSource() -> Results?
//    var source: Results? { get set }
//    func togglePlayPause()
//    func resetPlaybackProgress()
//    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String)
//    func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String)
//    func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool
//    var isFavorite: Bool { get set }
//
//}
//
//final class DetailPresenter {
//
//    private var artworkURL: String?
//    private var audioPlayer: AVPlayer?
//    private var isPlaying = false
//    private var playbackProgressObserver: Any?
//    unowned var view: DetailViewControllerProtocol!
//    var source: Results?
//    let router: DetailRouterProtocol!
//    var isFavorite = false
//
//
//// MARK: - Initialize
//
//    init(
//        view: DetailViewControllerProtocol,
//        router: DetailRouterProtocol
//    ) {
//        self.view = view
//        self.router = router
//    }
//
//}
//// MARK: - Extension
//
//extension DetailPresenter: DetailPresenterProtocol {
//
//// MARK: - Function
//
//    func viewDidLoad() {
//
//        guard let details = getSource() else { return }
//        updateArtworkURL()
//
//        if let artworkURL = artworkURL, let url = URL(string: artworkURL) {
//            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] (image, _, error, _, _, _) in
//                if let error = error {
//                    print("Image download error: \(error.localizedDescription)")
//                } else if let image = image {
//                    self?.view?.setArtistImage(image)
//                }
//            }
//        }
//
//        view.setArtistName(details.artistName ?? "")
//        view.setCollection(details.collectionName ?? "")
//        view.setTrackName(details.trackName ?? "")
//        view.setKind(details.primaryGenreName ?? "")
//        view.setTrackPrice(details.trackPrice ?? 0)
//        view.setCollectionPrice(details.collectionPrice ?? 0)
//        
//        let artistName = details.artistName ?? ""
//            let collectionName = details.collectionName ?? ""
//            let trackName = details.trackName ?? ""
//            isFavorite = isFavoriteArtist(artistName: artistName, collectionName: collectionName, trackName: trackName)
//            view.setFavoriteButtonImage(isFavorite: isFavorite)
//
//    }
//
//    func getSource() -> Results? {
//        return source
//    }
//
//    func togglePlayPause() {
//        if isPlaying {
//            pause()
//        } else {
//            play()
//        }
//    }
//
//    func resetPlaybackProgress() {
//        DispatchQueue.main.async { [weak self] in
//            self?.view?.setPlaybackProgress(0.0)
//        }
//    }
//
//    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "ArtistFavorites", in: managedContext)!
//        let favoriteArtist = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        favoriteArtist.setValue(artistName, forKey: "favoriteArtist")
//        favoriteArtist.setValue(collectionName, forKey: "favoriteCollection")
//        favoriteArtist.setValue(trackName, forKey: "favoriteTrackName")
//
//        do {
//            try managedContext.save()
//            print("Favorite artist saved.")
//            isFavorite = true
//            view.setFavoriteButtonImage(isFavorite: true)
//        } catch let error as NSError {
//            print("Could not save favorite artist. \(error), \(error.userInfo)")
//        }
//    }
//
//    func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtistFavorites")
//        fetchRequest.predicate = NSPredicate(format: "favoriteArtist == %@ AND favoriteCollection == %@ AND favoriteTrackName == %@", artistName, collectionName, trackName)
//
//        do {
//            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
//            if let favoriteArtist = results?.first {
//                managedContext.delete(favoriteArtist)
//                try managedContext.save()
//                print("Favorite artist deleted.")
//                isFavorite = false
//                view.setFavoriteButtonImage(isFavorite: false)
//            }
//        } catch let error as NSError {
//            print("Could not delete favorite artist. \(error), \(error.userInfo)")
//        }
//    }
//
//    func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtistFavorites")
//        fetchRequest.predicate = NSPredicate(format: "favoriteArtist == %@ AND favoriteCollection == %@ AND favoriteTrackName == %@", artistName, collectionName, trackName)
//
//        do {
//            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
//            return results?.count ?? 0 > 0
//        } catch let error as NSError {
//            print("Could not fetch favorite artist. \(error), \(error.userInfo)")
//            return false
//        }
//    }
//
//
//
//
//// MARK: - Private Function
//
//    private func updateArtworkURL() {
//        artworkURL = source?.artworkUrl100 ?? ""
//    }
//
//    private func play() {
//        guard let previewURLString = source?.previewUrl,
//              let previewURL = URL(string: previewURLString) else {
//            return
//        }
//
//        if audioPlayer == nil {
//            let playerItem = AVPlayerItem(url: previewURL)
//            audioPlayer = AVPlayer(playerItem: playerItem)
//            addPlaybackProgressObserver()
//            audioPlayer?.play() // Ses çalmasını burada başlatıyoruz
//        } else {
//            addPlaybackProgressObserver()
//            audioPlayer?.play()
//        }
//
//        isPlaying = true
//        updateButtonImage()
//    }
//
//    private func pause() {
//        audioPlayer?.pause()
//        isPlaying = false
//        removePlaybackProgressObserver()
//        DispatchQueue.main.async { [weak self] in
//            self?.view?.setButtonImage(UIImage(named: "playy-2"))
//        }
//    }
//
//    private func updateButtonImage() {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//
//            if self.isPlaying {
//                self.view?.setButtonImage(UIImage(named: "pausee-2"))
//            } else {
//                self.view?.setButtonImage(UIImage(named: "playy-2"))
//            }
//            if !self.isPlaying {
//                self.view?.setPlaybackProgress(0.0)
//            }
//        }
//    }
//
//    private func updatePlaybackProgress() {
//        guard let player = audioPlayer else { return }
//        let currentTime = Float(player.currentTime().seconds)
//        let duration = Float(player.currentItem?.duration.seconds ?? 0)
//        let progress = currentTime / duration
//        view?.setPlaybackProgress(progress)
//    }
//
//    private func addPlaybackProgressObserver() {
//        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//        playbackProgressObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
//            guard let duration = self?.audioPlayer?.currentItem?.duration.seconds else { return }
//            let progress = Float(time.seconds / duration)
//            self?.view?.setPlaybackProgress(progress)
//
//            // Duraklatıldığında ilerleme çubuğunun son konumuna güncellenmesi
//            if progress >= 1.0 {
//                self?.audioPlayer?.pause()
//                self?.isPlaying = false
//                self?.removePlaybackProgressObserver()
//                self?.updateButtonImage()
//            }
//        }
//    }
//
//    private func removePlaybackProgressObserver() {
//        if let observer = playbackProgressObserver {
//            audioPlayer?.removeTimeObserver(observer)
//            playbackProgressObserver = nil
//        }
//    }
//}
//
//

