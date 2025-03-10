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
    var collectionNftService: CollectionNftService { get }
    var orderService: OrderService { get }
    var profileService: ProfileService { get }
    var collections: AnyPublisher<[Collection], Never> { get }
    var state: AnyPublisher<CollectionsState, Never> { get }
    func loadData(skipCache: Bool)
    func loadNextPage(reset: Bool, skipCache: Bool)
    func sortCollections(by option: CollectionSortOptions)
    func getCollection(at indexPath: IndexPath) -> Collection
}

// MARK: - State
enum CollectionsState {
    case initial, loading, failed(Error), success
}

// MARK: - Sort
enum CollectionSortOptions: String {
    case none
    case name
    case nfts
}

final class CollectionsViewModel: CollectionsViewModelProtocol {
    let imageLoaderService: ImageLoaderService
    let collectionsService: CollectionService
    let collectionNftService: CollectionNftService
    let orderService: OrderService
    let profileService: ProfileService

    @Published private var _state: CollectionsState = .initial
    var state: AnyPublisher<CollectionsState, Never> { $_state.eraseToAnyPublisher() }

    @Published private var _collections: [Collection] = []
    var collections: AnyPublisher<[Collection], Never> { $_collections.eraseToAnyPublisher() }

    private let catalogSortOptionStorage: CollectionsSortOptionStorage
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private var sortBy: CollectionSortOptions
    private var isLoadingPage = false
    private var hasMorePages = true

    // MARK: - Init
    init(
        imageLoaderService: ImageLoaderService,
        collectionsService: CollectionService,
        collectionNftService: CollectionNftService,
        catalogSortOptionStorage: CollectionsSortOptionStorage,
        orderService: OrderService,
        profileService: ProfileService
    ) {
        self.imageLoaderService = imageLoaderService
        self.collectionsService = collectionsService
        self.collectionNftService = collectionNftService
        self.catalogSortOptionStorage = catalogSortOptionStorage
        self.sortBy = catalogSortOptionStorage.loadSortOption()
        self.orderService = orderService
        self.profileService = profileService
    }

    func getCollection(at indexPath: IndexPath) -> Collection {
        guard _collections.indices.contains(indexPath.row) else {
            fatalError("🔥 Index out of range: \(indexPath.row)")
        }
        return _collections[indexPath.row]
    }

    func sortCollections(by option: CollectionSortOptions) {
        sortBy = option
        catalogSortOptionStorage.saveSortOption(option)
        loadData()

    }

    func loadData(skipCache: Bool = false) {
        currentPage = 0
        hasMorePages = true

        loadNextPage(reset: true)
    }

    func loadNextPage(reset: Bool = false, skipCache: Bool = false) {
        guard !isLoadingPage, hasMorePages else { return }

        _state = .loading

        guard let collectionPlaceholder = Collection.placeholder else {
            _state = .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
            return
        }

        isLoadingPage = true

        if reset {
            _collections = (0..<4).map { _ in Collection.placeholder ?? collectionPlaceholder }
        } else {
            currentPage += 1
        }

        collectionsService.fetchCollections(
            page: currentPage,
            sortBy: sortBy,
            skipCache: skipCache
        )
        .map { [weak self] newCollections -> CollectionsState in
            guard
                let self = self
            else {
                return .failed(NSError(domain: "ViewModel", code: -1, userInfo: nil))
            }

            if newCollections.isEmpty {
                self.hasMorePages = false
            }

            if reset {
                self._collections = newCollections
            } else {
                let uniqueNew = newCollections.filter { newItem in
                    !self._collections.contains(where: { $0.id == newItem.id })
                }
                self._collections.append(contentsOf: uniqueNew)
                /// Доп. сортировка
                /// В API есть баг, неправильно сортирует по nfts
                if self.sortBy == .nfts {
                    self._collections.sort { $0.nfts.count > $1.nfts.count }
                }
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
