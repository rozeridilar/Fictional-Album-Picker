//
//  PhotoDetailView.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import SwiftUI
import PhotosUI

struct PhotoDetailView: View {
    @ObservedObject var viewModel: PhotoDetailViewModel

    var body: some View {
        VStack {
            if let uiImage = viewModel.asset.loadUIImage() {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            HStack {
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                }
            }
        }
        .padding()
        .navigationTitle("Photo Detail")
    }
}

extension PHAsset {
    func loadUIImage() -> UIImage? {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        var image: UIImage?
        manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { img, _ in
            image = img
        }
        return image
    }
}
