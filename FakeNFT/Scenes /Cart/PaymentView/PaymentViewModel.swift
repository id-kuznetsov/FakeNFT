//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 18.02.2025.
//

import Foundation

final class PaymentViewModel: PaymentViewModelProtocol {
    
    // MARK: - Public Properties
    
    var onItemsUpdate: (() -> Void)?
    
    var paymentMethodCount: Int {
        currencyCards.count
    }
    
    // MARK: - Private Properties
    
    private let orderService: OrderService
    private var currencyCards: [CurrencyCard] = []
    
    // MARK: - Initialisers
    
    init(orderService: OrderService) {
        self.orderService = orderService
    }
    
    // MARK: - Public Methods
    
    func getItem(at index: Int) -> CurrencyCard {
        currencyCards[index]
    }
    
    func loadData() {
        orderService.getCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.currencyCards = currencies.map { currency in
                    CurrencyCard(
                        name: currency.title,
                        shortName: currency.name,
                        imageURL: currency.image
                    )
                }
                self?.onItemsUpdate?()
            case .failure(let error):
                print("Error: \(error) in \(#function) \(#file)")
                // TODO: в cart-3 передать ошибку через алерт
            }
        }
    }
}


