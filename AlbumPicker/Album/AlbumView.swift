//
//  PhotoView.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import SwiftUI
import PhotosUI

struct AlbumView: View {
    let title: String
    let count: Int
    let asset: PHAsset?

    @State private var image: Image? = nil

    var body: some View {
        VStack(alignment: .leading) {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
            }

            Text(title)
                .font(.headline)

            Text("\(count) \(count == 1 ? "photo" : "photos")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .onAppear {
            loadAssetImage(targetSize: CGSize(width: 100, height: 100))
        }
    }

    func loadAssetImage(targetSize: CGSize) {
        guard let asset else {
            self.image = Image(systemName: "photo")
            return
        }

        let options = PHImageRequestOptions()
        options.version = .original
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            if let image {
                self.image = Image(uiImage: image)
            }
        }
    }
}
