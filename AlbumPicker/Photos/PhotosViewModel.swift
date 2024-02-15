//
//  PhotoViewModel.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import Foundation
import Photos

class PhotosViewModel: NSObject, ObservableObject {
    @Published var assets: PHFetchResult<PHAsset>

    init(assets: PHFetchResult<PHAsset>) {
        self.assets = assets
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension PhotosViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
          DispatchQueue.main.sync {
              if let changeDetails = changeInstance.changeDetails(for: self.assets) {
                  self.assets = changeDetails.fetchResultAfterChanges
              }
          }
      }
}
