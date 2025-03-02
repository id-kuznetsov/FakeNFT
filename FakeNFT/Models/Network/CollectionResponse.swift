//
//  CollectionResponse.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 28.02.2025.
//

import Foundation

struct CollectionResponse: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

extension CollectionResponse {
    func toUIModel() -> CollectionUI? {
        DateFormatter.defaultDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = DateFormatter.defaultDateFormatter.date(from: self.createdAt) else {
            print("DEBUG: Ошибка - Не удалось преобразовать дату - \(self.createdAt)")
            return nil
        }

        return CollectionUI(
            createdAt: date,
            name: self.name,
            cover: URL(string: self.cover),
            nfts: self.nfts,
            description: self.description,
            author: self.author,
            id: self.id
        )
    }
}
