//
//  OrderService.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 16.02.2025.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService{
    func getOrder(completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
