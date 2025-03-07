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
    ) -> AnyPublisher<[NftUI], Error>
}

final class CollectionNftServiceImpl: CollectionNftService {
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

    func fetchNfts(
        collectionId: String,
        nftIds: [String],
        skipCache: Bool = false
    ) -> AnyPublisher<[NftUI], Error> {
        let cachePublisher = cachePublisher(forCollectionId: collectionId)
        let networkPublisher = networkPublisher(forCollectionId: collectionId, nftIds: nftIds)

        if skipCache {
            return networkPublisher
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return cachePublisher
                .flatMap { cached -> AnyPublisher<[NftUI], Error> in
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
    ) -> AnyPublisher<[NftUI], Error> {
        let key = self.cacheKey(forCollectionId: id)

        return Future<[NftUI], Error> { promise in
            self.cacheService.load(type: [NftUI].self, forKey: key) { result in
                switch result {
                case .success(let (cachedNfts, lastUpdated)):
                    let cacheIsFresh = (Date().timeIntervalSince(lastUpdated) < self.cacheLifetime)
                    promise(.success(cacheIsFresh ? cachedNfts : []))
                    print(
                        "DEBUG: CollectionNftService - loaded from cache with key: \(key), items count: \(cachedNfts.count)"
                    )
                case .failure:
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func networkPublisher(
        forCollectionId id: String,
        nftIds: [String]
    ) -> AnyPublisher<[NftUI], Error> {
        return Future<[NftUI], Error> { promise in
            print(
                "DEBUG: CollectionNftService - fetching nfts for collection id: \(id) from network items count: \(nftIds.count)"
            )
            if !self.networkMonitor.isConnected {
                promise(.failure(NetworkMonitorError.noInternetConnection))
                return
            }

            let key = self.cacheKey(forCollectionId: id)

            let uniqueNftIds = Array(Set(nftIds))
            var convertedModels: [NftUI] = []

            for nftId in nftIds {
                let request = NFTRequest(id: nftId)

                self.networkClient.send(
                    request: request,
                    type: NftResponse.self
                ) { result in
                    switch result {
                    case .success(let response):
                        if let convertedModel = response.toUIModel() {
                            convertedModels.append(convertedModel)
                        }

                        if convertedModels.count == uniqueNftIds.count {
                            self.cacheService.save(data: convertedModels, forKey: key)
                            print(
                                "DEBUG: CollectionNftService - saved to cache with key: \(key), items count: \(convertedModels.count)"
                            )
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
