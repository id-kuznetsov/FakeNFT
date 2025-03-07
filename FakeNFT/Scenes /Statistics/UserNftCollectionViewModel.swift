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
    var orderedNfts: Set<String> { get }
    var onNftCollectionUpdated: (() -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var onErrorOccurred: ((String) -> Void)? { get set }
    var onNoNftAvailable: (() -> Void)? { get set }
    func loadNftCollection()
    func toggleLike(for nfts: String)
    func toggleCart(for nftIds: String)
}

final class UserNftCollectionViewModel: UserNftCollectionViewModelProtocol {
    
    // MARK: - Private properties
    private let nftService: NftService
    private let userService: UserService
    private let orderService: OrderService
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
    
    private(set) var orderedNfts: Set<String> = [] {
        didSet {
            onNftCollectionUpdated?()
        }
    }
    
    var onNftCollectionUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onNoNftAvailable: (() -> Void)?
    
    // MARK: - Initializers
    init(
        nftService: NftService,
        userService: UserService,
        orderService: OrderService,
        userId: String,
        nftIds: [String]
    ) {
        self.nftService = nftService
        self.userService = userService
        self.orderService = orderService
        self.userId = userId
        self.nftIds = nftIds
    }
    
    // MARK: - Public methods
    func loadNftCollection() {
        onLoadingStateChanged?(true)
        
        let group = DispatchGroup()
        
        loadUserLikes(using: group)
        loadNfts(using: group)
        loadOrder(using: group)
        
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
        
        userService.updateUserLikes(likes: Array(likedNfts)) { [weak self] result in
            switch result {
            case .success:
                self?.onNftCollectionUpdated?()
            case .failure(let error):
                self?.onErrorOccurred?("Ошибка обновления лайков: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleCart(for nftId: String) {
        if orderedNfts.contains(nftId) {
            orderedNfts.remove(nftId)
        } else {
            orderedNfts.insert(nftId)
        }
        
        orderService.updateOrder(nftIds: Array(orderedNfts)) { [weak self] result in
            switch result {
            case .success:
                self?.onNftCollectionUpdated?()
            case .failure(let error):
                self?.onErrorOccurred?("Ошибка обновления заказа: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func loadOrder(using group: DispatchGroup) {
        group.enter()
        orderService.fetchOrder { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let nftIds):
                self?.orderedNfts = Set(nftIds)
            case .failure(let error):
                self?.onErrorOccurred?("Ошибка загрузки заказа: \(error.localizedDescription)")
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
                self?.onErrorOccurred?("Ошибка загрузки лайков: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadNfts(using group: DispatchGroup) {
        var loadedNfts: [Nft] = []
        
        for nftId in nftIds {
            group.enter()
            nftService.loadNft(id: nftId) { [weak self] result in
                defer { group.leave() }
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    self?.onErrorOccurred?("Ошибка при загрузке NFT \(error.localizedDescription)")
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.nftCollection = self.sortNftCollection(loadedNfts)
            
            if self.nftCollection.isEmpty {
                self.onNoNftAvailable?()
            }
            
            self.onLoadingStateChanged?(false)
        }
    }
    
    private func sortNftCollection(_ nfts: [Nft]) -> [Nft] {
        nfts.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
