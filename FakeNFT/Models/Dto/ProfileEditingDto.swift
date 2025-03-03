import Foundation

struct ProfileEditingDto: Dto {
    var avatar: String
    var name: String
    var description: String
    var website: String
    
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

