//
//  CollectionsServiceAssembly.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 02.03.2025.
//

import UIKit

public final class CollectionsServiceAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let viewModel = CollectionsViewModel(
            imageLoaderService: servicesAssembler.imageLoaderService,
            collectionsService: servicesAssembler.collectionsService,
            collectionNftService: servicesAssembler.collectionNftService,
            catalogSortOptionStorage: servicesAssembler.collectionsSortOptionService
        )
        let viewController = CollectionsViewController(viewModel: viewModel)

        return viewController
    }
}
