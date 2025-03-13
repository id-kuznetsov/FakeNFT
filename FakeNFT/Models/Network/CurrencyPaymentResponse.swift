//
//  CurrencyPaymentResponse.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 03.03.2025.
//

import Foundation

struct CurrencyPaymentResponse: Decodable {
    let success: Bool
    let orderId, id: String
}
