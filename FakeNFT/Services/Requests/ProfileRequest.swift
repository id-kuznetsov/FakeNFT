//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 07.03.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let endpoint: URL?
    let dto: Dto?

    init() {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        self.dto = nil
    }
}
