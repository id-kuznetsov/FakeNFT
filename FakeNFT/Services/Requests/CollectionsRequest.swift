//
//  CollectionsRequest.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 28.02.2025.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    let page: Int
    let sortBy: String?

    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/collections")
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: "4")
        ]

        if let sortBy = sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }

        components?.queryItems = queryItems
        return components?.url
    }

    var dto: Dto?
}
