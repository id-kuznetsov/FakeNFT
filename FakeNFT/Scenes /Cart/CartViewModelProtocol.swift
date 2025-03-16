//
//  CartViewModelProtocol.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 17.02.2025.
//

import Foundation

protocol CartViewModelProtocol {
    var orderService: OrderService { get }
    var onItemsUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var itemsCount: Int { get }
    var isCartEmpty: Bool { get }

    func getItem(at index: Int) -> OrderCard
    func getTotalCost() -> Double
    func loadData()
    func sortItems(by sortOption: SortOption)
    func deleteItem(with nftId: String)
    func clearCart()
}
