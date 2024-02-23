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
    @Namespace private var heartAnimationNamespace

    private let heartIconId = "heartIcon"
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let uiImage = viewModel.asset.loadUIImage() {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width)
                }

                if viewModel.isFavorite {
                    Image(systemName: "heart.fill")
                        .matchedGeometryEffect(id: heartIconId, in: heartAnimationNamespace)
                        .font(.system(size: 60)) // Make the icon larger
                        .foregroundColor(.red)
                        .position(CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2))
                        .onTapGesture {
                            withAnimation {
                                viewModel.toggleFavorite()
                            }
                        }
                }
            }

            if !viewModel.isFavorite {
                Button(action: {
                    withAnimation {
                        viewModel.toggleFavorite()
                    }
                }) {
                    Image(systemName: "heart")
                        .matchedGeometryEffect(id: heartIconId, in: heartAnimationNamespace)
                }
                .position(CGPoint(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).maxY))
            }
        }
        .navigationTitle("Photo Detail")
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PhotoDetailViewModel(asset: PHAsset())

        PhotoDetailView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
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
