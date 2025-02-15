//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 15.02.2025.
//

import Foundation

protocol CartViewModelProtocol {
    func getItemsCount() -> Int
}

final class CartViewModel: CartViewModelProtocol {
    func getItemsCount() -> Int {
        7 // TODO: get from request
    }
    
    
}
