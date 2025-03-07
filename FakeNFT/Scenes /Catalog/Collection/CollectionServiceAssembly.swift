//
//  CollectionServiceAssembly.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 06.03.2025.
//

import UIKit

public final class CollectionServiceAssembly {
    private let imageLoaderService: ImageLoaderService
    private let collectionNftService: CollectionNftService
    private let collectionUI: CollectionUI

    init(
        imageLoaderService: ImageLoaderService,
        collectionNftService: CollectionNftService,
        collectionUI: CollectionUI,
    ) {
        self.imageLoaderService = imageLoaderService
        self.collectionNftService = collectionNftService
        self.collectionUI = collectionUI
    }

    public func build() -> UIViewController {
        let viewModel = CollectionViewModel(
            imageLoaderService: imageLoaderService,
            collectionNftService: collectionNftService,
            collectionUI: collectionUI
        )
        let viewController = CollectionViewController(viewModel: viewModel)

        return viewController
    }
}
