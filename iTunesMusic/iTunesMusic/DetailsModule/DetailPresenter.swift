//
//  DetailsPresenter.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import Foundation
import iTunesMusicAPI
import SDWebImage

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func getSource() -> Results?
    var source: Results? { get set }
}

final class DetailPresenter {
    
    var source: Results?
    private var artworkURL: String?
    unowned var view: DetailViewControllerProtocol!
    let router: DetailRouterProtocol!
    
    init(
        view: DetailViewControllerProtocol,
        router: DetailRouterProtocol
    ) {
        self.view = view
        self.router = router
    }
    func updateArtworkURL() {
          artworkURL = source?.artworkUrl100 ?? ""
      }
}
extension DetailPresenter: DetailPresenterProtocol {

    
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
    }
    func getSource() -> Results? {
        return source
    }
    
}
