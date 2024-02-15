//
//  PhotoDetailViewModel.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import Foundation
import Photos

class PhotoDetailViewModel: NSObject, ObservableObject {
    @Published var asset: PHAsset
    @Published var isFavorite: Bool

    init(asset: PHAsset) {
        self.asset = asset
        self.isFavorite = asset.isFavorite
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func toggleFavorite() {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest(for: self.asset)
            request.isFavorite = !self.isFavorite
        }, completionHandler: { success, error in
            if success {
                DispatchQueue.main.async {
                    self.isFavorite.toggle()
                }
            }
        })
    }
}

extension PhotoDetailViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            if let changeDetails = changeInstance.changeDetails(for: self.asset) {
                self.asset = changeDetails.objectAfterChanges ?? self.asset
                self.isFavorite = self.asset.isFavorite
            }
        }
    }
}
