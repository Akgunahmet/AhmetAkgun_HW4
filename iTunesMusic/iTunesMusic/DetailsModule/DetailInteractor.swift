//
//  DetailsInteractor.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//


import Foundation
import iTunesMusicAPI
import UIKit
import CoreData

// MARK: - Protocol

protocol DetailInteractorDelegate: AnyObject {
    func didSaveDataToCoreData()
}

protocol DetailInteractorProtocol {
    func saveDataToCoreData(source: Results?)
}

protocol DetailInteractorOutputProtocol {
    func saveDataToCoreData()
}

final class DetailInteractor: DetailInteractorProtocol {
    weak var delegate: DetailInteractorDelegate?
    
    func saveDataToCoreData(source: Results?) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        guard let details = source else { return }
        let entity = NSEntityDescription.entity(forEntityName: "ArtistFavorites", in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(details.artistName, forKey: "favoriteArtist")
        object.setValue(details.trackName, forKey: "favoriteSong")
        object.setValue(details.collectionName, forKey: "favoriteCollection")
        object.setValue(details.collectionPrice, forKey: "favoriteCollectionPrice")
        object.setValue(details.trackPrice, forKey: "favoriteTrackPrice")
        object.setValue(details.primaryGenreName, forKey: "favoriteKind")
        
        do {
            try context.save()
            print("Veriler Core Data'ya kaydedildi.")
            delegate?.didSaveDataToCoreData()
        } catch {
            print("Verileri kaydetme hatası: \(error.localizedDescription)")
        }
    }
}

extension DetailInteractor: DetailInteractorOutputProtocol {
    func saveDataToCoreData() {
        // Implementation not required
    }
}
//
//import Foundation
//import iTunesMusicAPI
//
//// MARK: - Protocol
//
//protocol DetailInteractorProtocol {
//
//}
//
//protocol DetailInteractorOutputProtocol {
//    func fetchNewsDetailOutput(_ result: Result<[Results], Error>)
//}
//
//
//final class DetailInteractor {
//    var output: HomeInteractorOutput?
//
//
//
//}

