//
//  UserNftCollectionViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 03.03.2025.
//

import UIKit

protocol UserNftCollectionViewModelProtocol {
    var nftCollection: [Nft] { get }
    var onNftCollectionUpdated: (() -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    func loadNftCollection()
}

final class UserNftCollectionViewModel: UserNftCollectionViewModelProtocol {
    
    // MARK: - Private properties
    private let nftService: NftService
    private let nftIds: [String]
    private(set) var nftCollection: [Nft] = [] {
        didSet {
            onNftCollectionUpdated?()
        }
    }
    
    var onNftCollectionUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    // MARK: - Initializers
    init(nftService: NftService, nftIds: [String]) {
        self.nftService = nftService
        self.nftIds = nftIds
    }
    
    // MARK: - Public methods
    func loadNftCollection() {
        onLoadingStateChanged?(true)
        
        let group = DispatchGroup()
        var loadedNfts: [Nft] = []
        
        for nftId in nftIds {
            group.enter()
            nftService.loadNft(id: nftId) { result in
                defer { group.leave() }
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    print("Ошибка при загрузке NFT \(nftId): \(error.localizedDescription)")
                }
            }
        }
        
        group.notify(queue: .main) {
            self.nftCollection = self.sortNftCollection(loadedNfts)
            self.onLoadingStateChanged?(false)
        }
    }
    
    private func sortNftCollection(_ nfts: [Nft]) -> [Nft] {
        nfts.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
