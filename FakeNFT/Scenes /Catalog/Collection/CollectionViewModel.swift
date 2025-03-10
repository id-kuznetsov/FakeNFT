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
    var nfts: AnyPublisher<[Nft], Never> { get }

    func loadData(skipCache: Bool)
    func updateProfile(with nftId: String)
}

// MARK: - State
enum CollectionState {
    case initial, loading, failed(Error), success
}

final class CollectionViewModel: CollectionViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let orderService: OrderService
    let profileService: ProfileService
    var collectionUI: Collection

    @Published private var _state: CollectionState = .initial
    var state: AnyPublisher<CollectionState, Never> { $_state.eraseToAnyPublisher() }

    @Published private var _nfts: [Nft] = []
    var nfts: AnyPublisher<[Nft], Never> { $_nfts.eraseToAnyPublisher() }

    private let collectionNftService: CollectionNftService
    private var cancellables = Set<AnyCancellable>()
    private var isLoading = false
    private var profile: Profile?

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
        guard let nftPlaceholder = Nft.placeholder else {
            _state = .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
            return
        }

        _state = .loading
        _nfts = (0..<3).map { _ in Nft.placeholder ?? nftPlaceholder }

        Publishers.Zip(
            collectionNftService.fetchNfts(
                collectionId: collectionUI.id,
                nftIds: collectionUI.nfts,
                skipCache: skipCache
            ),
            profileService.fetchProfileCombine(profile: nil, skipCache: skipCache)
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

    func updateProfile(with nftId: String) {
        guard
            var currentProfile = profile
        else {
            _state = .failed(
                NSError(domain: "ViewModel", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Profile is nil"
                ])
            )
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

                let updatedNfts = self._nfts.map { nft -> Nft in
                    var nftWithLike = nft
                    nftWithLike.isLiked = newProfile.likes.contains(nft.id)
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
