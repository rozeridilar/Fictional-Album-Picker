//
//  AlbumView.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import SwiftUI
import Photos

struct AlbumsView: View {
    @StateObject private var viewModel = AlbumViewModel()

    var body: some View {
        NavigationView {
            List {
                // Section for allPhotos
                if let allPhotos = viewModel.allPhotos.firstObject {
                    Section(header: Text(AlbumSectionType.all.description)) {
                        AlbumView(title: AlbumSectionType.all.description, count: viewModel.allPhotos.count, asset: allPhotos)
                    }
                }

                // Sections for smartAlbums and userCollections
                albumSection(for: viewModel.smartAlbums, title: AlbumSectionType.smartAlbums.description)
                albumSection(for: viewModel.userCollections, title: AlbumSectionType.userCollections.description)
            }
            .navigationTitle("Albums")
            .onAppear {
                Task {
                    await viewModel.checkPermissionAndFetchAssets()
                }
            }
        }
    }

    @ViewBuilder
    private func albumSection(for fetchResult: PHFetchResult<PHAssetCollection>, title: String) -> some View {
        Section(header: Text(title)) {
            ForEach(0..<fetchResult.count, id: \.self) { index in
                let assetCollection = fetchResult.object(at: index)
                let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
                if let firstAsset = assets.firstObject {
                    NavigationLink(destination: PhotosView(viewModel: PhotosViewModel(assets: assets))) {
                        AlbumView(title: assetCollection.localizedTitle ?? "Unknown Album",
                                  count: assets.count,
                                  asset: firstAsset)
                    }
                } else {
                    Text(assetCollection.localizedTitle ?? "Unknown Album")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    AlbumsView()
}
