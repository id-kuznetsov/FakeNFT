//
//  CollectionsViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import Foundation
import Combine

protocol CollectionsViewModelProtocol {
    var imageLoaderService: ImageLoaderService { get }
    var nftsService: NftsService { get }
    var collections: [CollectionUI] { get }
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { get }
    func numberOfRows() -> Int
    func getCollection(at indexPath: IndexPath) -> CollectionUI
}

final class CollectionsViewModel: CollectionsViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let nftsService: NftsService
    private let collectionsService: CollectionsService

    @Published var collections: [CollectionUI]
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { $collections }

    init(
        imageLoaderService: ImageLoaderService,
        collectionsService: CollectionsService,
        nftsService: NftsService
    ) {
        self.collections = []
        self.imageLoaderService = imageLoaderService
        self.nftsService = nftsService
        self.collectionsService = collectionsService

        collectionsService.loadCollections { collections in
            self.collections = collections
        }
    }

    func numberOfRows() -> Int {
        collections.count
    }

    func getCollection(at indexPath: IndexPath) -> CollectionUI {
        collections[indexPath.row]
    }
}
