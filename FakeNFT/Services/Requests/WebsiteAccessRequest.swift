//
//  WebsiteAccessRequest.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 26.02.2025.
//

import Foundation

struct WebsiteAccessRequest: NetworkRequest {
    let url: URL

    var endpoint: URL? { url }
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}
