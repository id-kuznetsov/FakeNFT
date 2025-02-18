//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import Foundation
import Combine

protocol CatalogViewModelProtocol {
    func numberOfRowsInSection() -> Int
    func getCategory(at indexPath: IndexPath) -> CollectionUI
}

final class CatalogViewModel {
    @Published var collections: [CollectionUI]

    private var dataProvider: CatalogDataProviderProtocol

    init(dataProvider: CatalogDataProviderProtocol) {
        self.collections = []
        self.dataProvider = dataProvider
        dataProvider.getCollections { collections in
            self.collections = collections
        }
    }

    func numberOfRowsInSection() -> Int {
        collections.count
    }

    func getCategory(at indexPath: IndexPath) -> CollectionUI {
        collections[indexPath.row]
    }
}
