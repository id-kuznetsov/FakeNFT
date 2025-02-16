import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let name: String
    let price: Double
    let rating: Int
}
