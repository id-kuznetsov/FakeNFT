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
    var userService: UserService { get }
    var collections: [CollectionUI] { get }
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { get }
    func numberOfRows() -> Int
    func getCollection(at indexPath: IndexPath) -> CollectionUI
    func sortByNftCount()
    func sortByCollectionName()
}

final class CollectionsViewModel: CollectionsViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let nftsService: NftsService
    let userService: UserService
    private let collectionsService: CollectionsService

    @Published var collections: [CollectionUI]
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { $collections }

    init(
        imageLoaderService: ImageLoaderService,
        collectionsService: CollectionsService,
        nftsService: NftsService,
        userService: UserService
    ) {
        self.collections = []
        self.imageLoaderService = imageLoaderService
        self.nftsService = nftsService
        self.collectionsService = collectionsService
        self.userService = userService

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

    func sortByNftCount() {
        print("🎯 Сортировка по количеству NFT")
    }

    func sortByCollectionName() {
        print("🎯 Сортировка по названию коллекции")
    }
}
