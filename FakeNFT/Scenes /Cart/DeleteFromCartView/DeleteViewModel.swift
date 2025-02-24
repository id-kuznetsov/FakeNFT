//
//  DeleteViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 25.02.2025.
//

import Foundation

protocol DeleteViewModelProtocol {
    
}

final class DeleteViewModel: DeleteViewModelProtocol {
    
    // MARK: - Private Properties
    
    private let orderService: OrderService
    
    // MARK: - Initialisers
    
    init(orderService: OrderService) {
        self.orderService = orderService
        
    }
    
    // MARK: - Public Methods
    
}
