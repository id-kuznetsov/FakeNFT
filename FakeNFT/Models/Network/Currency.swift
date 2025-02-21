//
//  Currency.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 21.02.2025.
//

import Foundation

typealias CurrencyValues = [Currency]

struct Currency: Decodable {
    let title, name: String
    let image: URL
    let id: String
}
