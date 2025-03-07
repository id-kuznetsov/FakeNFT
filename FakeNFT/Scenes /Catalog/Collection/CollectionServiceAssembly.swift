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
    private let orderService: OrderService
    private let profileService: ProfileService
    private let collectionUI: CollectionUI

    init(
        imageLoaderService: ImageLoaderService,
        collectionNftService: CollectionNftService,
        orderService: OrderService,
        profileService: ProfileService,
        collectionUI: CollectionUI,
    ) {
        self.imageLoaderService = imageLoaderService
        self.collectionNftService = collectionNftService
        self.orderService = orderService
        self.profileService = profileService
        self.collectionUI = collectionUI
    }

    public func build() -> UIViewController {
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
