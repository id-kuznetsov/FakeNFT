//
//  OrderService.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 16.02.2025.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void
typealias OrderPutCompletion = (Result<Order, Error>) -> Void
typealias CurrenciesCompletion = (Result<CurrencyValues, Error>) -> Void

protocol OrderService{
    func getOrder(completion: @escaping OrderCompletion)
    func getCurrencies(completion: @escaping CurrenciesCompletion)
    func putOrder(nfts: [String], completion: @escaping OrderPutCompletion)
    func getCurrentOrder() -> Order?
}

final class OrderServiceImpl: OrderService {
    
    private let networkClient: NetworkClient
    private var currentOrder: Order?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        
        networkClient.send(request: request, type: Order.self) { [weak self] result in
            switch result {
            case .success(let order):
                self?.currentOrder = order
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesRequest()
        
        networkClient.send(request: request, type: CurrencyValues.self) { result in
            switch result {
            case .success(let currencyValues):
                completion(.success(currencyValues))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putOrder(nfts: [String], completion: @escaping OrderPutCompletion) {
        let dto = OrderDtoObject(nfts: nfts)
        let request = OrderPutRequest(dto: dto)
        
        networkClient.send(request: request, type: Order.self) { [weak self] result in
            switch result {
            case .success(let order):
                self?.currentOrder = order
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentOrder() -> Order? {
        return currentOrder
    }
}
