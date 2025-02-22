//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import Foundation
import Combine

protocol CollectionViewModelProtocol {
    var collection: CollectionUI { get }
    var nfts: [NftUI] { get set }
    var nftsPublisher: Published<[NftUI]>.Publisher { get }
    func numberOfItems() -> Int
    func getCollection(at indexPath: IndexPath) -> NftUI
}

final class CollectionViewModel: CollectionViewModelProtocol {
    var collection: CollectionUI
    
    @Published var nfts: [NftUI]
    var nftsPublisher: Published<[NftUI]>.Publisher { $nfts }

    private let servicesAssembly: ServicesAssembly

    init(
        servicesAssembly: ServicesAssembly,
        collection: CollectionUI
    ) {
        self.servicesAssembly = servicesAssembly
        self.collection = collection
        self.nfts = []

        servicesAssembly.nftsService.loadNfts { nfts in
            self.nfts = nfts
        }
    }

    func numberOfItems() -> Int {
        nfts.count
    }

    func getCollection(at indexPath: IndexPath) -> NftUI {
        nfts[indexPath.row]
    }
}
