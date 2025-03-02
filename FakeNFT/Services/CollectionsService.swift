//
//  CollectionsService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

protocol CollectionsService {
    func fetchCollections(
        page: Int,
        sortBy: String?,
        completion: @escaping (Result<[CollectionUI], Error>) -> Void
    )
}

final class CollectionsServiceImpl {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - CollectionsService
extension CollectionsServiceImpl: CollectionsService {

    func fetchCollections(
        page: Int,
        sortBy: String?,
        completion: @escaping (Result<[CollectionUI], Error>) -> Void
    ) {
        let request = CollectionsRequest(page: page, sortBy: sortBy)

        networkClient.send(request: request, type: [CollectionResponse].self) { result in
            switch result {
            case .success(let response):
                let convertedModels = response.compactMap { responseModel -> CollectionUI? in
                    let uiModel = responseModel.toUIModel()
                    if uiModel == nil {
                        print("DEBUG: Ошибка преобразования для ID: \(responseModel.id)")
                    }
                    return uiModel
                }

                completion(.success(convertedModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
