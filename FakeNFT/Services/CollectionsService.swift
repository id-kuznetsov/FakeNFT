//
//  CollectionsService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 17.02.2025.
//

import Foundation

protocol CollectionsService {
    func loadCollections(completion: @escaping ([CollectionUI]) -> Void)
}

final class CollectionsServiceImpl {}

// MARK: - CollectionsService
extension CollectionsServiceImpl: CollectionsService {
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
                createdAt: Date(),
                name: "Peach",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Peach.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10"],
                description: "Lorem ipsum dolor. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ",
                author: "Barry Sheppard",
                id: "id3"
            ),
            CollectionUI(
                createdAt: Date(),
                name: "Blue",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Blue.png"),
                nfts: ["id1"],
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ",
                author: "Harold Chapman",
                id: "id4"
            ),
            CollectionUI(
                createdAt: Date(),
                name: "Brown",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                nfts: ["id1", "id2", "id3"],
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.  Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ",
                author: "Lourdes Harper",
                id: "id1"
            ),
//            CollectionUI(
//                createdAt: Date(),
//                name: "Baz",
//                cover: URL(string: "https://domain.tld/Gray.png"),
//                nfts: ["id1", "id2"],
//                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
//                author: "Darren Morris",
//                id: "id2"
//            ),
            CollectionUI(
                createdAt: Date(),
                name: "Quuux",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10", "id11"],
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
                author: "Peggy Leblanc",
                id: "id5"
            ),
            CollectionUI(
                createdAt: Date(),
                name: "Foo",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
                nfts: ["id1", "id2", "id3"],
                description: "Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
                author: "Peggy Leblanc",
                id: "id6"
            ),
            CollectionUI(
                createdAt: Date(),
                name: "Baz",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/White.png"),
                nfts: ["id1", "id2"],
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
                author: "Shawn Hardin",
                id: "id7"
            ),
            CollectionUI(
                createdAt: Date(),
                name: "Bar",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8", "id9", "id10"],
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
                author: "Shawn Hardin",
                id: "id8"
            ),
            CollectionUI(
                createdAt: Date(),
                name: "Quuuuuux",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1"],
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
                author: "Shawn Hardin",
                id: "id9"
            ),
            CollectionUI(
                createdAt: Date(),
                name: "Quuux",
                cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
                nfts: ["id1", "id2", "id3", "id4", "id5", "id6", "id7", "id8"],
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ",
                author: "Shawn Hardin",
                id: "id10"
            )
        ]
    }
}
