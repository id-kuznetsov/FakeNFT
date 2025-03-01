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
    var imageLoaderService: ImageLoaderService { get }
    var userService: UserService { get }
    var nfts: [NftUI] { get set }
    var nftsPublisher: Published<[NftUI]>.Publisher { get }
    func numberOfItems() -> Int
    func getCollection(at indexPath: IndexPath) -> NftUI
}

final class CollectionViewModel: CollectionViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let userService: UserService
    private let nftsService: NftsService

    var collection: CollectionUI

    @Published var nfts: [NftUI]
    var nftsPublisher: Published<[NftUI]>.Publisher { $nfts }

    private var collectionAuthors = [UserUI]()

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        nftsService: NftsService,
        collection: CollectionUI,
        userService: UserService
    ) {
        self.imageLoaderService = imageLoaderService
        self.nftsService = nftsService
        self.collection = collection
        self.nfts = []
        self.userService = userService

        nftsService.loadNfts { nfts in
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
