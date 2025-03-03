//
//  PaymentViewModelProtocol.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 22.02.2025.
//

import Foundation

protocol PaymentViewModelProtocol {
    var onItemsUpdate: (() -> Void)? { get set }
    var onPaymentProcessingStart: (() -> Void)? { get set }
    var onError: (() -> Void)? { get set }

    var paymentMethodCount: Int { get }
    
    func getItem(at index: Int) -> CurrencyCard
    func loadData()    
    func setSelectedCurrencyIndex(_ index: Int)
    func getSelectedCurrencyIndex() -> Int?
    func isCurrencySelected() -> Bool
    func paymentProcessing()
}
