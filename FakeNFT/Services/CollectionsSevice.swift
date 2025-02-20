//
//  CollectionsSevice.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

protocol CollectionsSevice {
    func loadCollections(completion: @escaping ([CollectionUI]) -> Void)
}

final class CollectionsServiceImpl {}

// MARK: - CollectionsSevice
extension CollectionsServiceImpl: CollectionsSevice {
    func loadCollections(completion: @escaping ([CollectionUI]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(CollectionUI.mock)
        }
    }
}

// MARK: - Mock
private extension CollectionUI {
    static var mock: [CollectionUI] {
        [
            CollectionUI(
                name: "Foo",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                nfts: ["id1", "id2", "id3"],
                id: "id1"
            ),
            CollectionUI(
                name: "Baz",
                cover: URL(string: "https://domain.tld/Gray.png"),
                nfts: ["id1", "id2"],
                id: "id2"
            ),
            CollectionUI(
                name: "Bar",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10"],
                id: "id3"
            ),
            CollectionUI(
                name: "Quux",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Blue.png"),
                nfts: ["id1"],
                id: "id4"
            ),
            CollectionUI(
                name: "Quuux",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10", "id11"],
                id: "id5"
            ),
            CollectionUI(
                name: "Foo",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                nfts: ["id1", "id2", "id3"],
                id: "id6"
            ),
            CollectionUI(
                name: "Baz",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/White.png"),
                nfts: ["id1", "id2"],
                id: "id7"
            ),
            CollectionUI(
                name: "Bar",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10"],
                id: "id8"
            ),
            CollectionUI(
                name: "Quuuuuux",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1"],
                id: "id9"
            ),
            CollectionUI(
                name: "Quuux",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8"],
                id: "id10"
            )
        ]
    }
}
