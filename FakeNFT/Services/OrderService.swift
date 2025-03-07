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
typealias SetCurrencyCompletion = (Result<CurrencyPaymentResponse, Error>) -> Void

protocol OrderService {
    func getOrder(completion: @escaping OrderCompletion)
    func getCurrencies(completion: @escaping CurrenciesCompletion)
    func putOrder(nfts: [String], completion: @escaping OrderPutCompletion)
    func setCurrencyBeforePayment(id: String, completion: @escaping SetCurrencyCompletion)
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

        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setCurrencyBeforePayment(id: String, completion: @escaping SetCurrencyCompletion) {
        let request = SetCurrencyRequest(id: id)

        networkClient.send(request: request, type: CurrencyPaymentResponse.self) {  result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
