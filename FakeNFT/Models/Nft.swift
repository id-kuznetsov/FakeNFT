import Foundation

struct Nft: Codable, Hashable {
    let name: String
    let images: [URL]
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isLiked)
        hasher.combine(isInCart)
    }

    static func == (lhs: Nft, rhs: Nft) -> Bool {
        return lhs.id == rhs.id &&
               lhs.isLiked == rhs.isLiked &&
               lhs.isInCart == rhs.isInCart
    }
}

extension Nft {
    static var placeholder: Nft? {
        guard let authorURL = URL(string: "https://example.com") else { return nil }

        return Nft(
            name: "",
            images: [],
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
