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

    var state: AnyPublisher<CollectionState, Never> { get }
    var nfts: AnyPublisher<[NftUI], Never> { get }

    func loadData(skipCache: Bool)
}

// MARK: - State
enum CollectionState {
    case initial, loading, failed(Error), success
}

final class CollectionViewModel: CollectionViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let orderService: OrderService
    let profileService: ProfileService
    var collectionUI: CollectionUI

    @Published private var _state: CollectionState = .initial
    var state: AnyPublisher<CollectionState, Never> { $_state.eraseToAnyPublisher() }

    @Published private var _nfts: [NftUI] = []
    var nfts: AnyPublisher<[NftUI], Never> { $_nfts.eraseToAnyPublisher() }

    private let collectionNftService: CollectionNftService
    private var cancellables = Set<AnyCancellable>()
    private var isLoading = false
    private var profile: ProfileUI = .placeholder

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        collectionNftService: CollectionNftService,
        orderService: OrderService,
        profileService: ProfileService,
        collectionUI: CollectionUI
    ) {
        self.imageLoaderService = imageLoaderService
        self.collectionNftService = collectionNftService
        self.orderService = orderService
        self.profileService = profileService
        self.collectionUI = collectionUI
    }

    func loadData(skipCache: Bool = false) {
        _state = .loading
        _nfts = (0..<3).map { _ in NftUI.placeholder }

        Publishers.Zip(
            collectionNftService.fetchNfts(
                collectionId: collectionUI.id,
                nftIds: collectionUI.nfts,
                skipCache: skipCache
            ),
            profileService.fetchProfileCombine()
        )
        .map { [weak self] nfts, profile -> CollectionState in
            guard let self = self else {
                return .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
            }
            self.profile = profile

            let updatedNfts = nfts.map { nft in
                var nftWithLike = nft
                nftWithLike.isLiked = profile.likes.contains(nft.id)
                return nftWithLike
            }
            .sorted { $0.isLiked && !$1.isLiked }

            self._nfts = updatedNfts
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
}
