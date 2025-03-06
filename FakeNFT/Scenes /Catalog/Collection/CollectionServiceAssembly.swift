//
//  CollectionServiceAssembly.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 06.03.2025.
//

import UIKit

public final class CollectionServiceAssembly {
    private let imageLoaderService: ImageLoaderService
    private let nftService: NftService
    private let collectionUI: CollectionUI

    init(
        imageLoaderService: ImageLoaderService,
        nftService: NftService,
        collectionUI: CollectionUI,
    ) {
        self.imageLoaderService = imageLoaderService
        self.nftService = nftService
        self.collectionUI = collectionUI
    }

    public func build() -> UIViewController {
        let viewModel = CollectionViewModel(
            imageLoaderService: imageLoaderService,
            nftService: nftService,
            collectionUI: collectionUI
        )
        let viewController = CollectionViewController(viewModel: viewModel)

        return viewController
    }
}
