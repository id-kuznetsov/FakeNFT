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
    private enum Params: String {
        case avatar, name, description, website
    }
    
    func asDictionary() -> [String : String] {
        [Params.avatar.rawValue: avatar, 
         Params.name.rawValue: name,
         Params.description.rawValue: description,
         Params.website.rawValue: website]
    }
}
