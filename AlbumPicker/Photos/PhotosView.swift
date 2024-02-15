//
//  PhotosView.swift
//  AlbumPicker
//
//  Created by Rozeri Dağtekin on 15.02.24.
//

import SwiftUI
import PhotosUI

struct PhotosView: View {
    @ObservedObject var viewModel: PhotosViewModel

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(viewModel.assets.objects(at: IndexSet(integersIn: 0..<viewModel.assets.count)), id: \.self) { asset in
                    NavigationLink(destination: PhotoDetailView(viewModel: PhotoDetailViewModel(asset: asset))) {
                        AlbumView(title: "Some Title", count: viewModel.assets.count, asset: asset)
                    }
                }
            }
        }
        .navigationTitle("Photos")
    }
}

#Preview {
    PhotosView(viewModel: PhotosViewModel(assets: PHFetchResult<PHAsset>()))
}
