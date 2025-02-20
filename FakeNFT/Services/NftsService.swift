//
//  NftsService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import Foundation

protocol NftsService {
    func loadNfts(completion: @escaping ([NftUI]) -> Void)
}

final class NftsServiceImpl {}

// MARK: - NftsService
extension NftsServiceImpl: NftsService {
    func loadNfts(completion: @escaping ([NftUI]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(NftUI.mock)
        }
    }
}

// MARK: - Mock
extension NftUI {
    static var mock: [NftUI] {
        [
            NftUI(
                createdAt: Date(),
                name: "Foo",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 5,
                description: "explicari lobortis rutrum evertitur fugit convenire ligula",
                price: 28.27,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "1"
            ),
            NftUI(
                createdAt: Date(),
                name: "Baz",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 2,
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
                price: 50,
                author: URL(string: "https://domain.tld/"),
                id: "2"
            ),
            NftUI(
                createdAt: Date(),
                name: "Bar",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 1,
                description: "Lorem ipsum dolor",
                price: 8.77,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "3"
            ),
            NftUI(
                createdAt: Date(),
                name: "Quux",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 0,
                description: "",
                price: 88.7,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "4"
            ),
            NftUI(
                createdAt: Date(),
                name: "Quuux",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 4,
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
                price: 0,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "5"
            ),
            NftUI(
                createdAt: Date(),
                name: "Quuuux",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 3,
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr",
                price: 28.2,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "6"
            ),
            NftUI(
                createdAt: Date(),
                name: "Quuuuux",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 5,
                description: "Lorem ipsum dolor sit amet",
                price: 0,
                author: nil,
                id: "7"
            ),
            NftUI(
                createdAt: Date(),
                name: "Quuuuuux",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 3,
                description: "Lorem ipsum dolor sit amet",
                price: 40.07,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "8"
            ),
            NftUI(
                createdAt: Date(),
                name: "Quuuuuuux",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 2,
                description: "Lorem ipsum dolor sit amet",
                price: 0,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "9"
            ),
            NftUI(
                createdAt: Date(),
                name: "Quuuuuuuux",
                images: [
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png"),
                    URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"),
                ],
                rating: 1,
                description: "Lorem ipsum dolor sit amet",
                price: 28.27,
                author: URL(string: "https://unruffled_cohen.fakenfts.org/"),
                id: "10"
            ),
        ]
    }
}
