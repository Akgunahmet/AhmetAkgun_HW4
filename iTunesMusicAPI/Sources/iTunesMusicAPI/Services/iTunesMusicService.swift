//
//  File.swift
//  
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import Foundation
import Alamofire

enum Constants: String {
    case iTunesAPIBaseURL = "https://itunes.apple.com"
}

public protocol iTunesMusicServiceProtocol: AnyObject {
    func searchSongs(_ word: String, completion: @escaping (Result<[Results], Error>) -> Void)
}
public class iTunesMusicService: iTunesMusicServiceProtocol {
    public init() {}
    
    public func searchSongs(_ word: String, completion: @escaping (Result<[Results], Error>) -> Void) {

        let queryItemTerm = URLQueryItem(name: "term", value: word)
        let queryItemCountry = URLQueryItem(name: "country", value: "tr")
        let queryItemEntity = URLQueryItem(name: "entity", value: "song")
        let queryItemAttribute = URLQueryItem(name: "attribute", value: "mixTerm")

        var urlComponents = URLComponents(string: Constants.iTunesAPIBaseURL.rawValue + "/search")
        urlComponents?.queryItems = [queryItemTerm, queryItemCountry, queryItemEntity, queryItemAttribute]
        
        guard let url = urlComponents?.url else {
            let error = NSError(domain: "iTunesMusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL is not valid"])
            completion(.failure(error))
            return
        }
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let response = try decoder.decode(Song.self, from: data)
                    if let results = response.results {
                        completion(.success(results))
                    } else {
                        let error = NSError(domain: "iTunesMusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No results found"])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


//public class iTunesMusicService: iTunesMusicServiceProtocol {
//    public init() {}
//
//    public func searchSongs(_ word: String, completion: @escaping (Result<[Results], Error>) -> Void) {
//        let queryItem = URLQueryItem(name: "term", value: word)
//
//        var urlComponents = URLComponents(string: Constants.iTunesAPIBaseURL.rawValue + "/search")
//        urlComponents?.queryItems = [queryItem]
//
//        guard let url = urlComponents?.url else {
//            let error = NSError(domain: "iTunesMusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL is not valid"])
//            completion(.failure(error))
//            return
//        }
//
//        AF.request(url).responseData { response in
//            switch response.result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//
//                do {
//                    let response = try decoder.decode(Song.self, from: data)
//                    if let results = response.results {
//                        completion(.success(results))
//                    } else {
//                        let error = NSError(domain: "iTunesMusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No results found"])
//                        completion(.failure(error))
//                    }
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}


//import Foundation
//import Alamofire
//
//enum Constants: String {
//    case iTunesAPIBaseURL = "https://itunes.apple.com"
//}
//
//public protocol iTunesMusicServiceProtocol: AnyObject {
//    func searchSong(_ word: String, completion: @escaping (Result<Song, Error>) -> Void)
//}
//
//public class iTunesMusicService: iTunesMusicServiceProtocol {
//    public init() {}
//// MARK: - Public Methods
//    public func searchSong(_ word: String, completion: @escaping (Result<Song, Error>) -> Void) {
//        let queryItem = URLQueryItem(name: "term", value: word)
//
//         var urlComponents = URLComponents(string: Constants.iTunesAPIBaseURL.rawValue + "/search")
//         urlComponents?.queryItems = [queryItem]
//
//         guard let url = urlComponents?.url else {
//             let error = NSError(domain: "iTunesMusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL is not valid"])
//             completion(.failure(error))
//             return
//         }
//        AF.request(url).responseData { response in
//            switch response.result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//
//                do {
//                    let response = try decoder.decode(Song.self, from: data)
//                    if let results = response.results, let firstElement = results.first {
//                        let song = Song(resultCount: response.resultCount, results: [firstElement])
//                        completion(.success(song))
//                    } else {
//                        let error = NSError(domain: "iTunesMusicService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No results found"])
//                        completion(.failure(error))
//                    }
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//}

