//
//  SortOption.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 14.02.2025.
//

import Foundation

enum SortOption: CaseIterable {
    case name
    case nftCount
    case price
    case rating
    case title

    var title: String {
        switch self {
        case .name: return L10n.SortOption.name
        case .nftCount: return L10n.SortOption.nftCount
        case .price: return L10n.SortOption.price
        case .rating: return L10n.SortOption.rating
        case .title: return L10n.SortOption.title
        }
    }
}
