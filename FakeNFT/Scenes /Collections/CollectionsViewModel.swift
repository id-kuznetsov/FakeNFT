//
//  CollectionsViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import Foundation
import Combine

protocol CollectionsViewModelProtocol {
    var servicesAssembly: ServicesAssembly { get }
    var collections: [CollectionUI] { get }
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { get }
    func numberOfRows() -> Int
    func getCollection(at indexPath: IndexPath) -> CollectionUI
}

final class CollectionsViewModel: CollectionsViewModelProtocol {
    let servicesAssembly: ServicesAssembly

    @Published var collections: [CollectionUI]
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { $collections }

    init(servicesAssembly: ServicesAssembly) {
        self.collections = []
        self.servicesAssembly = servicesAssembly
        servicesAssembly.collectionsService.loadCollections { collections in
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
