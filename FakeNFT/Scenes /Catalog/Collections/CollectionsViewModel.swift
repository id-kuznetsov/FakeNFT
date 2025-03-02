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

    var collections: [CollectionUI] { get }
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { get }

    var state: CollectionsState { get }
    var statePublisher: Published<CollectionsState>.Publisher { get }

    func loadData()
    func numberOfRows() -> Int
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

    @Published var state = CollectionsState.initial
    var statePublisher: Published<CollectionsState>.Publisher { $state }

    @Published var collections = [CollectionUI]()
    var collectionsPublisher: Published<[CollectionUI]>.Publisher { $collections }

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

    func numberOfRows() -> Int {
        collections.count
    }

    func getCollection(at indexPath: IndexPath) -> CollectionUI {
        collections[indexPath.row]
    }

    func sortByNftCount() {
        print("🎯 Сортировка по количеству NFT")
    }

    func sortByCollectionName() {
        print("🎯 Сортировка по названию коллекции")
    }

    func loadData() {
        collectionsService.fetchCollections(
            page: currentPage,
            sortBy: sortBy
        )
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Ошибка: \(error)")
                }
            }, receiveValue: { [weak self] data in
                self?.collections = data
            })
            .store(in: &cancellables)
    }
}
