//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 18.02.2025.
//

import Foundation

protocol PaymentViewModelProtocol {
    var onItemsUpdate: (() -> Void)? { get set }
    var paymentMethodCount: Int { get }
    
    func getItem(at index: Int) -> CurrencyCard
    func loadData()
}

final class PaymentViewModel: PaymentViewModelProtocol {
    var onItemsUpdate: (() -> Void)?
    
    private var currencyCards: [CurrencyCard] = []
    
    var paymentMethodCount: Int {
        currencyCards.count
    }
    
    func getItem(at index: Int) -> CurrencyCard {
        currencyCards[index]
    }
    
    func loadData() {
        // TODO: load data
    }
    
    
}
