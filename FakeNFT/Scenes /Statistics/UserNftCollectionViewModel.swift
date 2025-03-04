//
//  UserNftCollectionViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 03.03.2025.
//

import UIKit

protocol UserNftCollectionViewModelProtocol {
    var nftCollection: [NftItem] { get }
    var onNftCollectionUpdated: (() -> Void)? { get set }
    func loadNftCollection()
}

final class UserNftCollectionViewModel: UserNftCollectionViewModelProtocol {
    
    // MARK: - Private properties
    private(set) var nftCollection: [NftItem] = [] {
        didSet {
            onNftCollectionUpdated?()
        }
    }
    
    var onNftCollectionUpdated: (() -> Void)?
    
    // MARK: - Public methods
    func loadNftCollection() {
        nftCollection = [
            NftItem(imageName: "nft1", name: "Archie", rating: 4, price: 1.78, isFavorite: true),
            NftItem(imageName: "nft2", name: "Emma", rating: 3, price: 1.78, isFavorite: false),
            NftItem(imageName: "nft3", name: "Stella", rating: 3, price: 1.78, isFavorite: true),
            NftItem(imageName: "nft4", name: "Toast", rating: 2, price: 1.78, isFavorite: false),
            NftItem(imageName: "nft5", name: "Zeus", rating: 2, price: 1.78, isFavorite: false)
        ]
    }
}
