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
    var collectionUI: CollectionUI

    @Published private var _state: CollectionState = .initial
    var state: AnyPublisher<CollectionState, Never> { $_state.eraseToAnyPublisher() }

    @Published private var _nfts: [NftUI] = []
    var nfts: AnyPublisher<[NftUI], Never> { $_nfts.eraseToAnyPublisher() }

    private let collectionNftService: CollectionNftService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        collectionNftService: CollectionNftService,
        collectionUI: CollectionUI
    ) {
        self.imageLoaderService = imageLoaderService
        self.collectionNftService = collectionNftService
        self.collectionUI = collectionUI
    }

    func loadData(skipCache: Bool = false) {
        _state = .loading

        _nfts = (0..<3).map { _ in NftUI.placeholder }

        collectionNftService.fetchNfts(
            collectionId: collectionUI.id,
            nftIds: collectionUI.nfts,
            skipCache: skipCache
        )
        .map { [weak self] newNfts -> CollectionState in
            guard
                let self = self
            else {
                return .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
            }

            self._nfts = newNfts

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

//    func numberOfItems() -> Int {
//        nfts.count
//    }

}
