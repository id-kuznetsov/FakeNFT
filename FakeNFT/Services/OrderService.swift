//
//  OrderService.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 06.03.2025.
//

import Foundation

protocol OrderService {
    func fetchOrder(completion: @escaping (Result<[String], Error>) -> Void)
    func updateOrder(nftIds: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

final class OrderServiceImpl: OrderService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchOrder(completion: @escaping (Result<[String], Error>) -> Void) {
        let request = OrderRequest()
        networkClient.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(nftIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let request = OrderUpdateRequest(orderItemIDs: nftIds)
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
