//
//  CachedUsers.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 20.02.2025.
//

import Foundation

final class CachedUsers: NSObject, Codable {
    let users: [User]
    let timestamp: TimeInterval

    init(users: [User], timestamp: TimeInterval) {
        self.users = users
        self.timestamp = timestamp
    }
}
