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
    var onPaymentProcessingStart: (() -> Void)?
    var onError: (() -> Void)?
    
    var paymentMethodCount: Int {
        currencyCards.count
    }
    
    // MARK: - Private Properties
    
    private var selectedCurrencyIndex: Int?
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
                self?.onError?()
            }
        }
    }
    
    func setSelectedCurrencyIndex(_ index: Int) {
        selectedCurrencyIndex = index
    }
    
    func getSelectedCurrencyIndex() -> Int? {
        return selectedCurrencyIndex
    }
    
    func isCurrencySelected() -> Bool {
        return selectedCurrencyIndex != nil
    }
    
    func paymentProcessing() {
        guard let id = selectedCurrencyIndex else {
            return
        }
        
        orderService.setCurrencyBeforePayment(id: "\(id)") { [weak self] result in
            switch result {
            case .success(let response):
                if response.success == true {
                    self?.onPaymentProcessingStart?()
                }
            case .failure(let error):
                print("Error: \(error) in \(#function) \(#file)")
                self?.onError?()
            }
        }
    }
}
