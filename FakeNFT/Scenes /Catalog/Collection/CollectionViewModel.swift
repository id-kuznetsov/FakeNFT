//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import Foundation
import Combine

protocol CollectionViewModelProtocol {
    var collectionUI: Collection { get }
    var imageLoaderService: ImageLoaderService { get }

    var state: AnyPublisher<CollectionState, Never> { get }
    var nfts: AnyPublisher<[CatalogNft], Never> { get }

    func loadData(skipCache: Bool)
    func updateProfile(with nftId: String)
    func updateOrder(with nftId: String)
}

// MARK: - State
enum CollectionState {
    case initial, loading, failed(Error), success
}

enum CollectionError: Error {
    case updateProfile
}

final class CollectionViewModel: CollectionViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let orderService: OrderService
    let profileService: ProfileService
    var collectionUI: Collection

    @Published private var _state: CollectionState = .initial
    var state: AnyPublisher<CollectionState, Never> { $_state.eraseToAnyPublisher() }

    @Published private var _nfts: [CatalogNft] = []
    var nfts: AnyPublisher<[CatalogNft], Never> { $_nfts.eraseToAnyPublisher() }

    private let collectionNftService: CollectionNftService
    private var cancellables = Set<AnyCancellable>()
    private var isLoading = false
    private var profile: CatalogProfile?
    private var order: CatalogOrder?

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        collectionNftService: CollectionNftService,
        orderService: OrderService,
        profileService: ProfileService,
        collectionUI: Collection
    ) {
        self.imageLoaderService = imageLoaderService
        self.collectionNftService = collectionNftService
        self.orderService = orderService
        self.profileService = profileService
        self.collectionUI = collectionUI
    }

    func loadData(skipCache: Bool = false) {
        guard let nftPlaceholder = CatalogNft.placeholder else {
            _state = .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
            return
        }

        _state = .loading
        _nfts = (0..<3).map { _ in CatalogNft.placeholder ?? nftPlaceholder }

        Publishers.Zip3(
            collectionNftService.fetchNfts(
                collectionId: collectionUI.id,
                nftIds: collectionUI.nfts,
                skipCache: skipCache
            ),
            profileService.fetchProfileCombine(profile: nil, skipCache: skipCache),
            orderService.fetchOrderCombine(order: nil, skipCache: skipCache)
        )
        .map { [weak self] nfts, profile, order -> CollectionState in
            guard let self = self else {
                return .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
            }
            self.profile = profile
            self.order = order

            let updatedNfts = nfts.map { nft in
                var updatedNft = nft
                updatedNft.isLiked = profile.likes.contains(nft.id)
                updatedNft.isInCart = order.nfts.contains(nft.id)
                return updatedNft
            }

            self._nfts = updatedNfts.sorted { self.priority(for: $0) > self.priority(for: $1) }
            return .success
        }
        .catch { error -> Just<CollectionState> in
            Just(.failed(error))
        }
        .sink { [weak self] newState in
            self?._state = newState
        }
        .store(in: &cancellables)
    }

    func updateProfile(with nftId: String) {
        guard
            var currentProfile = profile
        else {
            print("DEBUG: CollectionViewModel - updateProfile - Profile is nil")
            _state = .failed(CollectionError.updateProfile)
            return
        }

        _state = .loading

        if currentProfile.likes.contains(nftId) {
            currentProfile.likes.removeAll { $0 == nftId }
        } else {
            currentProfile.likes.append(nftId)
        }

        self.profile = currentProfile

        profileService.fetchProfileCombine(profile: currentProfile, skipCache: true)
            .map { [weak self] newProfile -> CollectionState in
                guard let self = self else {
                    return .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
                }

                self.profile = newProfile

                let updatedNfts = self._nfts.map { nft -> CatalogNft in
                    var nftWithLike = nft
                    nftWithLike.isLiked = newProfile.likes.contains(nft.id)
                    return nftWithLike
                }

                self._nfts = updatedNfts.sorted { self.priority(for: $0) > self.priority(for: $1) }
                return .success
            }
            .catch { error -> Just<CollectionState> in
                Just(.failed(error))
            }
            .sink { [weak self] newState in
                self?._state = newState
            }
            .store(in: &cancellables)
    }

    func updateOrder(with nftId: String) {
        guard
            var currentOrder = order
        else {
            _state = .failed(
                NSError(domain: "ViewModel", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Profile is nil"
                ])
            )
            return
        }

        _state = .loading

        if currentOrder.nfts.contains(nftId) {
            currentOrder.nfts.removeAll { $0 == nftId }
        } else {
            currentOrder.nfts.append(nftId)
        }

        self.order = currentOrder

        orderService.fetchOrderCombine(order: currentOrder, skipCache: true)
            .map { [weak self] newOrder -> CollectionState in
                guard let self = self else {
                    return .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
                }

                self.order = newOrder

                let updatedNfts = self._nfts.map { nft -> CatalogNft in
                    var nftWithCart = nft
                    nftWithCart.isInCart = newOrder.nfts.contains(nft.id)
                    return nftWithCart
                }

                self._nfts = updatedNfts.sorted { self.priority(for: $0) > self.priority(for: $1) }
                return .success
            }
            .catch { error -> Just<CollectionState> in
                Just(.failed(error))
            }
            .sink { [weak self] newState in
                self?._state = newState
            }
            .store(in: &cancellables)
    }

    private func priority(for nft: CatalogNft) -> Int {
        return (nft.isLiked ? 1 : 0) + (nft.isInCart ? 1 : 0)
    }
}
