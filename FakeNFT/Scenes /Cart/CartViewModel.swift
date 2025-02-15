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
}

final class CartViewModel: CartViewModelProtocol {
    func getItemsCount() -> Int {
        1 // TODO: get from request
    }
    
    func getItem(at index: Int) -> OrderCard {
        // TODO: get from request ❌
        let url = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")! // force for test
        return OrderCard(
            name: "Mock Name",
            rating: 5,
            price: 1.78,
            imageURL: url
        )
    }
    
    
}
