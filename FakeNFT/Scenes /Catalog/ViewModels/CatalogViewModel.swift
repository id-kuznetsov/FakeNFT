//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import Foundation
import Combine

protocol CatalogViewModelProtocol {
    var collections: [CollectionUI] { get set }
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { get }
    func numberOfRows() -> Int
    func getCollection(at indexPath: IndexPath) -> CollectionUI
}

final class CatalogViewModel: CatalogViewModelProtocol {
    @Published var collections: [CollectionUI]
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { $collections }

    private var dataProvider: CatalogDataProviderProtocol

    init(dataProvider: CatalogDataProviderProtocol) {
        self.collections = []
        self.dataProvider = dataProvider
        dataProvider.getCollections { collections in
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
