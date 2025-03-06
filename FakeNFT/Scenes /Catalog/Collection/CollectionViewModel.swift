//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import Foundation
import Combine

protocol CollectionViewModelProtocol {
    var collectionUI: CollectionUI { get }
    var imageLoaderService: ImageLoaderService { get }
//    var userService: UserService { get }
    var nfts: [NftUI] { get set }
    var nftsPublisher: Published<[NftUI]>.Publisher { get }
    func numberOfItems() -> Int
//    func getCollection(at indexPath: IndexPath) -> NftUI
}

final class CollectionViewModel: CollectionViewModelProtocol {
    let imageLoaderService: ImageLoaderService
//    let userService: UserService
    private let nftService: NftService

    var collectionUI: CollectionUI

    @Published var nfts = [NftUI]()
    var nftsPublisher: Published<[NftUI]>.Publisher { $nfts }

//    private var collectionAuthors = [UserUI]()

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        nftService: NftService,
        collectionUI: CollectionUI
    ) {
        self.imageLoaderService = imageLoaderService
        self.nftService = nftService
        self.collectionUI = collectionUI
    }

//    func loadNftsForCollection() {
//        for nftId in collectionUI.nfts {
//            nftService.getNft(for: nftId) { [weak self] result in
//                switch result {
//                case .success(let nft):
//                    self?.nfts.append(nft)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//    }

    func numberOfItems() -> Int {
        nfts.count
    }

//    func getCollection(at indexPath: IndexPath) -> NftUI {
//        nfts[indexPath.row]
//    }
}
