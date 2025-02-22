//
//  CollectionsViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import Foundation
import Combine

protocol CollectionsViewModelProtocol {
    var nftsService: NftsService { get }
    var collections: [CollectionUI] { get }
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { get }
    func numberOfRows() -> Int
    func getCollection(at indexPath: IndexPath) -> CollectionUI
}

final class CollectionsViewModel: CollectionsViewModelProtocol {

    let nftsService: NftsService
    private let collectionsService: CollectionsService

    @Published var collections: [CollectionUI]
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { $collections }

    init(
        collectionsService: CollectionsService,
        nftsService: NftsService
    ) {
        self.collections = []
        self.collectionsService = collectionsService
        self.nftsService = nftsService

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
