import Foundation

struct Profile: Codable, Hashable {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [String]
    var likes: [String]
    let id: String
}

extension Profile {
    func toResponse() -> ProfileDTO? {

        return ProfileDTO(
            name: self.name,
            avatar: self.avatar.absoluteString,
            description: self.description,
            website: self.website.absoluteString,
            nfts: self.nfts,
            likes: self.likes,
            id: self.id
        )
    }
}
