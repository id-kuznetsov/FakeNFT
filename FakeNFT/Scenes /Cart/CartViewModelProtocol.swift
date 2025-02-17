//
//  CartViewModelProtocol.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 17.02.2025.
//

import Foundation

protocol CartViewModelProtocol {
    var onItemsUpdate: (() -> Void)? { get set }
    var itemsCount: Int { get }
    
    func getItem(at index: Int) -> OrderCard
    func getTotalCost() -> Double
    func loadData()
    func sortItems(by sortOption: SortOption)
}
