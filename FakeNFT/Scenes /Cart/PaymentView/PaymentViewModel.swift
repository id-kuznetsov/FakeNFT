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
//        currencyCards.count
        8
    }
    
    func getItem(at index: Int) -> CurrencyCard {
//        currencyCards[index]
        CurrencyCard(
            name: "Bitcoin",
            shortName: "BTC",
            imageURL: URL(string:"https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png")! // TODO: for test
        )
    }
    
    func loadData() {
        // TODO: load data
    }
    
    
}
