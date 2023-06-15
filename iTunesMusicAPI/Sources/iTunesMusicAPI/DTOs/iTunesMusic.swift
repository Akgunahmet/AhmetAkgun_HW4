//
//  File.swift
//  
//
//  Created by Ahmet Akgün on 6.06.2023.
//

import Foundation


public struct Song: Decodable {
    public let resultCount: Int?
    public let results: [Results]?
}

// MARK: - Result
public struct Results: Decodable {
    public let kind: String?
    public let artistName: String?
    public let collectionName: String?
    public let trackName: String?
    public let trackViewUrl: String?
    public let previewUrl: String? // ses
    public let artworkUrl100: String?
    public let collectionPrice: Double?
    public let trackPrice: Double?
    public let releaseDate: Date?
    public let primaryGenreName: String?
}

