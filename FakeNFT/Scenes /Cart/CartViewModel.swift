//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 15.02.2025.
//

import Foundation

protocol CartViewModelProtocol {
    func getItemsCount() -> Int
    func getItem(at index: Int) -> OrderCard
    func getTotalCost() -> Double
    func loadData()
}

final class CartViewModel: CartViewModelProtocol {
    
    // MARK: - Private Properties
    
    private let servicesAssembly: ServicesAssembly
    private var nftsInCart: [OrderCard] = [
        OrderCard(
            name: "Mock Name",
            rating: 5,
            price: 1.78,
            imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")! // force for test
        )
    ]
    
    // MARK: - Initialisers
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        loadData()
    }
    
    // MARK: - Public Methods
    
    func getItemsCount() -> Int {
        nftsInCart.count
    }
    
    func getItem(at index: Int) -> OrderCard {
        nftsInCart[index]
    }
    
    func getTotalCost() -> Double {
        nftsInCart.reduce(0, { $0 + $1.price})        
    }
    
    func loadData() {
        servicesAssembly.orderService.getOrder(completion: { result in
            switch result {
            case .success(let order):
                print("Заказ получен: \(order)")
                let nftsInOrder = order.nfts
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        })
    }
    
    
    
}
