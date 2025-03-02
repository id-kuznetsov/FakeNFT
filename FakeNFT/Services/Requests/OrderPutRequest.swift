//
//  OrderPutRequest.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 02.03.2025.
//

import Foundation


struct OrderPutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    
    var dto: (any Dto)?
}

struct OrderDtoObject: Dto {
    let nfts: [String]
    
    enum CodingKeys: String, CodingKey {
        case nfts = "nfts"
    }
    
    func asDictionary() -> [String : String] {
        if !nfts.isEmpty {
            return [
                CodingKeys.nfts.rawValue: nfts.map{ $0.lowercased() }.joined(separator: ",")
            ]
        } else {
            return [
                CodingKeys.nfts.rawValue: "null"
            ]
            
        }
    }
}
