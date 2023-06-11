//
//  DetailsInteractor.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 6.06.2023.
//


import Foundation
import iTunesMusicAPI
import CoreData


// MARK: - Protocol

protocol DetailInteractorProtocol {
    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String)
    func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String)
    func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool
    func showFavoriteArtist(completion: @escaping ([String]) -> Void)
}

protocol DetailInteractorOutputProtocol {
    func saveFavoriteArtistOutput()

}


final class DetailInteractor {
    var output: DetailInteractorOutputProtocol?
    var presenter: DetailPresenter?


 
}

extension DetailInteractor: DetailInteractorProtocol {

    func showFavoriteArtist(completion: @escaping ([String]) -> Void) {
         
          
          let managedContext = AppDelegate.containerPersistent.viewContext
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArtistFavorites")

          do {
              let favoriteArtists = try managedContext.fetch(fetchRequest)
              var artistInfoList: [String] = []
              
              for artist in favoriteArtists {
                  if let artistName = artist.value(forKeyPath: "favoriteArtist") as? String,
                     let collectionName = artist.value(forKeyPath: "favoriteCollection") as? String,
                     let trackName = artist.value(forKeyPath: "favoriteTrackName") as? String {
                      
                      let artistInfo = "\(artistName) - \(collectionName) - \(trackName)"
                      artistInfoList.append(artistInfo)
                  }
              }
              
              completion(artistInfoList)
              
          } catch let error as NSError {
              print("Could not fetch favorite artists. \(error), \(error.userInfo)")
              completion([])
          }
      }

    func saveFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
        
            let managedContext = AppDelegate.containerPersistent.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ArtistFavorites", in: managedContext)!
            let favoriteArtist = NSManagedObject(entity: entity, insertInto: managedContext)

            favoriteArtist.setValue(artistName, forKey: "favoriteArtist")
            favoriteArtist.setValue(collectionName, forKey: "favoriteCollection")
            favoriteArtist.setValue(trackName, forKey: "favoriteTrackName")

            do {
                try managedContext.save()
                print("Favorite artist saved.")
            } catch let error as NSError {
                print("Could not save favorite artist. \(error), \(error.userInfo)")
            }
        }

        func deleteFavoriteArtist(artistName: String, collectionName: String, trackName: String) {
            let managedContext = AppDelegate.containerPersistent.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtistFavorites")
            fetchRequest.predicate = NSPredicate(format: "favoriteArtist == %@ AND favoriteCollection == %@ AND favoriteTrackName == %@", artistName, collectionName, trackName)

            do {
                let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let favoriteArtist = results?.first {
                    managedContext.delete(favoriteArtist)
                    try managedContext.save()
                    print("Favorite artist deleted.")
                }
            } catch let error as NSError {
                print("Could not delete favorite artist. \(error), \(error.userInfo)")
            }
        }

        func isFavoriteArtist(artistName: String, collectionName: String, trackName: String) -> Bool {
            let managedContext = AppDelegate.containerPersistent.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtistFavorites")
            fetchRequest.predicate = NSPredicate(format: "favoriteArtist == %@ AND favoriteCollection == %@ AND favoriteTrackName == %@", artistName, collectionName, trackName)

            do {
                let count = try managedContext.count(for: fetchRequest)
                return count > 0
            } catch let error as NSError {
                print("Could not fetch favorite artist. \(error), \(error.userInfo)")
                return false
            }
        }
    
}


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



