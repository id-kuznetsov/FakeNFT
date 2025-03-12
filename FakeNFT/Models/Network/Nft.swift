import Foundation

struct Nft: Decodable, Hashable {
    let id: NftID
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let createdAt: String
}

extension Nft {
    var authorName: String {
        if let url = URL(string: author),
           let host = url.host {
            let components = host.components(separatedBy: ".")
            return components.first ?? ""
        } else {
            return ""
        }
    }
    
    var previewImage: String? {
        images.first?.absoluteString
    }
}

typealias NftID = String
