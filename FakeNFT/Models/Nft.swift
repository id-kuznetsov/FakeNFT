import Foundation

struct Nft: Codable, Hashable {
    let name: String
    let imagesUrl: [URL]
    let rating: Int
    let description: String
    let price: Double
    let authorUrl: URL
    let id: String
    var isLiked: Bool
    var isInCart: Bool
    let isPlaceholder: Bool

    var formattedPrice: String {
        String(format: "%.2f", price)
    }
}

extension Nft {
    static var placeholder: Nft? {
        guard let authorURL = URL(string: "https://example.com") else { return nil }

        return Nft(
            name: "",
            imagesUrl: [],
            rating: 0,
            description: "",
            price: 0,
            authorUrl: authorURL,
            id: UUID().uuidString,
            isLiked: false,
            isInCart: false,
            isPlaceholder: true
        )
    }
}
