//
//  CollectionNftService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 06.03.2025.
//

import Foundation
import Combine

protocol CollectionNftService {
    func fetchNfts(
        collectionId: String,
        nftIds: [String],
        skipCache: Bool
    ) -> AnyPublisher<[CatalogNft], Error>
}

final class CollectionNftServiceImpl: CollectionNftService {
    private let networkClient: NetworkClient
    private let cacheService: CacheService
    private let networkMonitor: NetworkMonitor
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
            .sink { _ in }
            .store(in: &cancellables)
    }

    func fetchNfts(
        collectionId: String,
        nftIds: [String],
        skipCache: Bool = false
    ) -> AnyPublisher<[CatalogNft], Error> {
        let cachePublisher = cachePublisher(forCollectionId: collectionId)
        let networkPublisher = networkPublisher(forCollectionId: collectionId, nftIds: nftIds)

        if skipCache {
            return networkPublisher
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return cachePublisher
                .flatMap { cached -> AnyPublisher<[CatalogNft], Error> in
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

    private func cacheKey(forCollectionId id: String) -> String {
        return "collection_id_\(id)"
    }

    private func cachePublisher(
        forCollectionId id: String
    ) -> AnyPublisher<[CatalogNft], Error> {
        let key = self.cacheKey(forCollectionId: id)

        return Future<[CatalogNft], Error> { promise in
            self.cacheService.load(type: [CatalogNft].self, forKey: key) { result in
                switch result {
                case .success(let cacheResult):
                    promise(.success(cacheResult.data))
                case .failure(let error):
                    if let cacheError = error as? CacheError, cacheError == .emptyOrStale {
                        promise(.success([]))
                    } else {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func networkPublisher(
        forCollectionId id: String,
        nftIds: [String]
    ) -> AnyPublisher<[CatalogNft], Error> {
        return Future<[CatalogNft], Error> { promise in
            if !self.networkMonitor.isConnected {
                promise(.failure(NetworkMonitorError.noInternetConnection))
                return
            }

            let key = self.cacheKey(forCollectionId: id)

            let uniqueNftIds = (NSOrderedSet(array: nftIds).array as? [String]) ?? []
            var convertedModels: [CatalogNft] = []

            for nftId in uniqueNftIds {
                let request = NFTRequest(id: nftId)

                self.networkClient.send(
                    request: request,
                    type: NftDTO.self
                ) { result in
                    switch result {
                    case .success(let response):
                        if let convertedModel = response.toDomainModel() {
                            convertedModels.append(convertedModel)
                        }

                        if convertedModels.count == uniqueNftIds.count {
                            /// API doesn't provide ttl
                            let ttl: TimeInterval? = nil
                            self.cacheService.save(data: convertedModels, ttl: ttl, forKey: key)
                            promise(.success(convertedModels))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
