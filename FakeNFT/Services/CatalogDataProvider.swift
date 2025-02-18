//
//  CatalogDataProvider.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

protocol CatalogDataProviderProtocol {
    func getCollections(completion: @escaping ([CollectionUI]) -> Void)
}

final class CatalogDataProvider {}

// MARK: - CatalogDataProviderProtocol
extension CatalogDataProvider: CatalogDataProviderProtocol {
    func getCollections(completion: @escaping ([CollectionUI]) -> Void) {
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
                cover: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Felis_catus-cat_on_snow.jpg/2560px-Felis_catus-cat_on_snow.jpg")!,
                nfts: ["id1", "id2", "id3"],
                id: "id1"
            ),
            CollectionUI(
                name: "Foo",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!,
                nfts: ["id1", "id2"],
                id: "id1"
            ),
            CollectionUI(
                name: "Foo",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/White.png")!,
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10"],
                id: "id1"
            ),
            CollectionUI(
                name: "Foo",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png")!,
                nfts: ["id1"],
                id: "id1"
            ),
            CollectionUI(
                name: "Foo",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Blue.png")!,
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10", "id11", "id12", "id13", "id14", "id15"],
                id: "id1"
            ),
        ]
    }
}
