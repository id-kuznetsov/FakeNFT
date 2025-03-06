//
//  UserNftCollectionViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 03.03.2025.
//

import UIKit

protocol UserNftCollectionViewModelProtocol {
    var nftCollection: [Nft] { get }
    var likedNfts: Set<String> { get }
    var onNftCollectionUpdated: (() -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    func loadNftCollection()
    func toggleLike(for nfts: String)
}

final class UserNftCollectionViewModel: UserNftCollectionViewModelProtocol {
    
    // MARK: - Private properties
    private let nftService: NftService
    private let userService: UserService
    private let userId: String
    private let nftIds: [String]
    
    private(set) var nftCollection: [Nft] = [] {
        didSet {
            onNftCollectionUpdated?()
        }
    }
    
    private(set) var likedNfts: Set<String> = [] {
        didSet {
            onNftCollectionUpdated?()
        }
    }
    
    var onNftCollectionUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    // MARK: - Initializers
    init(nftService: NftService, userService: UserService, userId: String, nftIds: [String]) {
        self.nftService = nftService
        self.userService = userService
        self.userId = userId
        self.nftIds = nftIds
    }
    
    // MARK: - Public methods
    func loadNftCollection() {
        onLoadingStateChanged?(true)
        
        let group = DispatchGroup()
        
        loadUserLikes(using: group)
        loadNfts(using: group)
        
        group.notify(queue: .main) {
            self.onLoadingStateChanged?(false)
        }
    }
    
    func toggleLike(for nftId: String) {
        if likedNfts.contains(nftId) {
            likedNfts.remove(nftId)
        } else {
            likedNfts.insert(nftId)
        }
        
        userService.updateUserLikes(likes: Array(likedNfts)) { result in
            if case .failure(let error) = result {
                print("Ошибка обновления лайков: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadUserLikes(using group: DispatchGroup) {
        group.enter()
        userService.fetchUserLikes() { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let likes):
                self?.likedNfts = Set(likes)
            case .failure(let error):
                print("Ошибка загрузки лайков: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadNfts(using group: DispatchGroup) {
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
        
        group.notify(queue: .main) { [weak self] in
            self?.nftCollection = self?.sortNftCollection(loadedNfts) ?? []
        }
    }
    
    private func sortNftCollection(_ nfts: [Nft]) -> [Nft] {
        nfts.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
