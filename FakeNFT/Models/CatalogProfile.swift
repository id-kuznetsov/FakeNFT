import Foundation

struct CatalogProfile: Codable, Hashable {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [String]
    var likes: [String]
    let id: String
}

extension CatalogProfile {
    func toDTO() -> CatalogProfileDTO? {

        return CatalogProfileDTO(
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
