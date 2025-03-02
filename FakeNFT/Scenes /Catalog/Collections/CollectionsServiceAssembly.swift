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

    public func build(/*with input: NftDetailInput*/) -> UIViewController {
        let viewModel = CollectionsViewModel(
//            input: input,
            imageLoaderService: servicesAssembler.imageLoaderService,
            collectionsService: servicesAssembler.collectionsService,
            nftsService: servicesAssembler.nftsService,
            userService: servicesAssembler.userService
        )
        let viewController = CollectionsViewController(viewModel: viewModel)
//        presenter.view = viewController
        return viewController
    }
}
