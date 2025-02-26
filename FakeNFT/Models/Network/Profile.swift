import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension Profile: Dto {
    func asDictionary() -> [String : String] {
        ["name": name,
         "description": description,
         "website": website,
         "likes": likes.isEmpty ? "null": likes.joined(separator: ", ")]
    }
}
