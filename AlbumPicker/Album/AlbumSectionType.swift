//
//  AlbumSectionType.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import Foundation

enum AlbumSectionType: Int, CustomStringConvertible {
  case all, smartAlbums, userCollections

  var description: String {
    switch self {
    case .all: return "All Photos"
    case .smartAlbums: return "Smart Albums"
    case .userCollections: return "User Collections"
    }
  }
}
