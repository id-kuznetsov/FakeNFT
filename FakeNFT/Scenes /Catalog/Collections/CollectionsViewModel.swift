//
//  CollectionsViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import Foundation
import Combine

// MARK: - Protocol
protocol CollectionsViewModelProtocol {
    var imageLoaderService: ImageLoaderService { get }
    var nftsService: NftsService { get }
    var userService: UserService { get }

    var collections: AnyPublisher<[CollectionUI], Never> { get }
    var state: AnyPublisher<CollectionsState, Never> { get }

    func loadData()
    func getCollection(at indexPath: IndexPath) -> CollectionUI
    func sortByNftCount()
    func sortByCollectionName()
}

// MARK: - State
enum CollectionsState {
    case initial, loading, failed(Error), success
}

final class CollectionsViewModel: CollectionsViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let nftsService: NftsService
    let userService: UserService
    private let collectionsService: CollectionsService

    @Published private var _state: CollectionsState = .initial
    var state: AnyPublisher<CollectionsState, Never> { $_state.eraseToAnyPublisher() }

    @Published private var _collections: [CollectionUI] = []
    var collections: AnyPublisher<[CollectionUI], Never> { $_collections.eraseToAnyPublisher() }

    private var cancellables = Set<AnyCancellable>()

    private var currentPage = 0
    private var sortBy: String?

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        collectionsService: CollectionsService,
        nftsService: NftsService,
        userService: UserService
    ) {
        self.imageLoaderService = imageLoaderService
        self.nftsService = nftsService
        self.collectionsService = collectionsService
        self.userService = userService
    }

    func getCollection(at indexPath: IndexPath) -> CollectionUI {
        guard _collections.indices.contains(indexPath.row) else {
            fatalError("🔥 Index out of range: \(indexPath.row)")
        }
        return _collections[indexPath.row]
    }

    func sortByNftCount() {
        _collections.sort { $0.nfts.count > $1.nfts.count }
        _collections = _collections
    }

    func sortByCollectionName() {
        // TODO: add loadData with sortBy name
        _collections.sort { $0.name < $1.name }
        _collections = _collections
    }

    func loadData() {
        _state = .loading

        collectionsService.fetchCollections(page: currentPage, sortBy: sortBy)
            .map { collections -> CollectionsState in
                self._collections = collections
                return .success
            }
            .catch { error -> Just<CollectionsState> in
                Just(.failed(error))
            }
            .sink { [weak self] newState in
                self?._state = newState
            }
            .store(in: &cancellables)
    }
}
