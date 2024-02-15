//
//  AlbumViewModel.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import Foundation
import Photos

class AlbumViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var allPhotos = PHFetchResult<PHAsset>()
    @Published var smartAlbums = PHFetchResult<PHAssetCollection>()
    @Published var userCollections = PHFetchResult<PHAssetCollection>()
    @Published var sections: [AlbumSectionType] = [.all, .smartAlbums, .userCollections]
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func checkPermissionAndFetchAssets() async {
        let granted = await requestPermissionIfNeeded()
        if granted {
            DispatchQueue.main.async {
                self.fetchAssets()
            }
        }
    }
    
    private func requestPermissionIfNeeded() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return newStatus == .authorized || newStatus == .limited
        default:
            return false
        }
    }
    
    func fetchAssets() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    }
}

extension AlbumViewModel {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
            
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
            }
            
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
            }
        }
    }
}
