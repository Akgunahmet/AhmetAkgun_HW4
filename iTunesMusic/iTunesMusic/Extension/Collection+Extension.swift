//
//  Collection+Extension.swift
//  iTunesMusic
//
//  Created by Ahmet Akgün on 8.06.2023.
//

import Foundation

//MARK: - Collections
public extension Collection where Indices.Iterator.Element == Index {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Iterator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
