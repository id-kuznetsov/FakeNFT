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
    var collectionsService: CollectionService { get }
    var nftsService: NftsService { get }
    var userService: UserService { get }
    var collections: AnyPublisher<[CollectionUI], Never> { get }
    var state: AnyPublisher<CollectionsState, Never> { get }
    func loadData()
    func loadNextPage(reset: Bool)
    func sortCollections(by option: CollectionSortOptions)
    func getCollection(at indexPath: IndexPath) -> CollectionUI
}

// MARK: - State
enum CollectionsState {
    case initial, loading, failed(Error), success
}

// MARK: - Sort
enum CollectionSortOptions: String {
    case none
    case name = "name"
    case nfts = "nfts"
}

final class CollectionsViewModel: CollectionsViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let nftsService: NftsService
    let userService: UserService
    let collectionsService: CollectionService

    @Published private var _state: CollectionsState = .initial
    var state: AnyPublisher<CollectionsState, Never> { $_state.eraseToAnyPublisher() }
    @Published private var _collections: [CollectionUI] = []
    var collections: AnyPublisher<[CollectionUI], Never> { $_collections.eraseToAnyPublisher() }

    private let collectionsSortOptionStorageService: CollectionsSortOptionStorageService
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private var sortBy: CollectionSortOptions
    private var isLoadingPage = false
    private var hasMorePages = true

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        collectionsService: CollectionService,
        nftsService: NftsService,
        userService: UserService,
        collectionsSortOptionStorageService: CollectionsSortOptionStorageService
    ) {
        self.imageLoaderService = imageLoaderService
        self.nftsService = nftsService
        self.collectionsService = collectionsService
        self.userService = userService
        self.collectionsSortOptionStorageService = collectionsSortOptionStorageService
        self.sortBy = collectionsSortOptionStorageService.loadSortOption()
    }

    func getCollection(at indexPath: IndexPath) -> CollectionUI {
        guard _collections.indices.contains(indexPath.row) else {
            fatalError("🔥 Index out of range: \(indexPath.row)")
        }
        return _collections[indexPath.row]
    }

    func sortCollections(by option: CollectionSortOptions) {
        sortBy = option
        collectionsSortOptionStorageService.saveSortOption(option)
        loadData()

    }
    
    func loadData() {
        currentPage = 0
        hasMorePages = true
        loadNextPage(reset: true)
    }

    func loadNextPage(reset: Bool = false) {
        guard !isLoadingPage, hasMorePages else { return }

        _state = .loading
        isLoadingPage = true

        if reset {
            _collections = (0..<4).map { _ in CollectionUI.placeholder }
        } else {
            currentPage += 1
        }

        collectionsService.fetchCollections(page: currentPage, sortBy: sortBy)
            .map { [weak self] newCollections -> CollectionsState in

                if newCollections.isEmpty {
                    self?.hasMorePages = false
                }

                if reset {
                    self?._collections = newCollections
                } else {
                    self?._collections.append(contentsOf: newCollections)
                }

                return .success
            }
            .catch { error -> Just<CollectionsState> in
                Just(.failed(error))
            }
            .sink { [weak self] newState in
                self?.isLoadingPage = false
                self?._state = newState
            }
            .store(in: &cancellables)
    }
}
