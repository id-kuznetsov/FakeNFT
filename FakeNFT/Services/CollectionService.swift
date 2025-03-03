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
        sortBy: CollectionSortOptions
    ) -> AnyPublisher<[CollectionUI], Error>
}

final class CollectionServiceImpl: CollectionService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchCollections(page: Int, sortBy: CollectionSortOptions) -> AnyPublisher<[CollectionUI], Error> {
        let request = CollectionsRequest(page: page, sortBy: sortBy)

        return Deferred {
            Future<[CollectionUI], Error> { [weak self] promise in
                guard let self = self else { return }

                self.networkClient.send(request: request, type: [CollectionResponse].self) { result in
                    switch result {
                    case .success(let response):
                        let convertedModels = response.compactMap { responseModel -> CollectionUI? in
                            let uiModel = responseModel.toUIModel()
                            if uiModel == nil {
                                print("DEBUG: Ошибка преобразования для ID: \(responseModel.id)")
                            }
                            return uiModel
                        }
                        promise(.success(convertedModels))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
