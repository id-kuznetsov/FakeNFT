//
//  CollectionService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation
import Combine

protocol CollectionService {
    func fetchCollections(
        page: Int,
        sortBy: CollectionSortOptions,
        skipCache: Bool
    ) -> AnyPublisher<[CollectionUI], Error>
}

final class CollectionServiceImpl: CollectionService {
    private let networkClient: NetworkClient
    private let cacheService: CacheService
    private let networkMonitor: NetworkMonitor
    private let cacheLifetime: TimeInterval = 10 * 60
    private var cancellables = Set<AnyCancellable>()

    init(
        networkClient: NetworkClient,
        cacheService: CacheService,
        networkMonitor: NetworkMonitor
    ) {
        self.networkClient = networkClient
        self.cacheService = cacheService
        self.networkMonitor = networkMonitor

        self.networkMonitor.connectivityPublisher
            .sink { isConnected in
                print("Сеть доступна: \(isConnected)")
            }
            .store(in: &cancellables)
    }

    func fetchCollections(
        page: Int,
        sortBy: CollectionSortOptions,
        skipCache: Bool = false
    ) -> AnyPublisher<[CollectionUI], Error> {
        let cachePublisher = cachePublisher(forPage: page, sortBy: sortBy)
        let networkPublisher = networkPublisher(forPage: page, sortBy: sortBy)

        if skipCache {
            return networkPublisher
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return cachePublisher
                .flatMap { cached -> AnyPublisher<[CollectionUI], Error> in
                    if cached.isEmpty {
                        return networkPublisher
                    } else {
                        return Just(cached)
                            .setFailureType(to: Error.self)
                            .append(networkPublisher)
                            .eraseToAnyPublisher()
                    }
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

    private func cacheKey(
        forPage page: Int,
        sortBy: CollectionSortOptions
    ) -> String {
        return "collections_page_\(page)_sortedBy_\(sortBy.rawValue)"
    }

    private func cachePublisher(
        forPage page: Int,
        sortBy: CollectionSortOptions
    ) -> AnyPublisher<[CollectionUI], Error> {
        let key = cacheKey(forPage: page, sortBy: sortBy)

        return Future<[CollectionUI], Error> { promise in
            self.cacheService.load(type: [CollectionUI].self, forKey: key) { result in
                switch result {
                case .success(let (cachedCollections, lastUpdated)):
                    let cacheIsFresh = (Date().timeIntervalSince(lastUpdated) < self.cacheLifetime)
                    promise(.success(cacheIsFresh ? cachedCollections : []))
                case .failure:
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func networkPublisher(
        forPage page: Int,
        sortBy: CollectionSortOptions
    ) -> AnyPublisher<[CollectionUI], Error> {
        return Future<[CollectionUI], Error> { promise in
            if !self.networkMonitor.isConnected {
                promise(.failure(NetworkMonitorError.noInternetConnection))
                return
            }

            let key = self.cacheKey(forPage: page, sortBy: sortBy)
            let request = CollectionsRequest(page: page, sortBy: sortBy)

            self.networkClient.send(
                request: request,
                type: [CollectionResponse].self
            ) { result in
                switch result {
                case .success(let response):
                    let convertedModels = response.compactMap { $0.toUIModel() }
                    self.cacheService.save(data: convertedModels, forKey: key)
                    promise(.success(convertedModels))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
