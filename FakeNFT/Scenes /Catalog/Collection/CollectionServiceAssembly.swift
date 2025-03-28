//
//  CollectionServiceAssembly.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 06.03.2025.
//

import UIKit

final class CollectionServiceAssembly {
    private let imageLoaderService: ImageLoaderService
    private let collectionNftService: CollectionNftService
    private let orderService: OrderService
    private let profileService: ProfileService
    private let collectionUI: Collection

    init(
        imageLoaderService: ImageLoaderService,
        collectionNftService: CollectionNftService,
        orderService: OrderService,
        profileService: ProfileService,
        collectionUI: Collection
    ) {
        self.imageLoaderService = imageLoaderService
        self.collectionNftService = collectionNftService
        self.orderService = orderService
        self.profileService = profileService
        self.collectionUI = collectionUI
    }

    func build() -> UIViewController {
        let viewModel = CollectionViewModel(
            imageLoaderService: imageLoaderService,
            collectionNftService: collectionNftService,
            orderService: orderService,
            profileService: profileService,
            collectionUI: collectionUI
        )
        let viewController = CollectionViewController(viewModel: viewModel)

        return viewController
    }
}
