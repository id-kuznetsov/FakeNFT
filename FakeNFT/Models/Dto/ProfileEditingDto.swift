import Foundation

struct ProfileEditingDto: Dto {
    private let avatar: String?
    private let name: String?
    private let description: String?
    private let website: String?
    
    init(avatar: String? = nil, 
         name: String? = nil,
         description: String? = nil,
         website: String? = nil) {
        self.avatar = avatar
        self.name = name
        self.description = description
        self.website = website
    }
    
    func asDictionary() -> [String : String] {
        var dict: [String: String] = [:]
        if let avatar { dict["avatar"] = avatar }
        if let name { dict["name"] = name }
        if let description { dict["description"] = description }
        if let website { dict["website"] = website }
        return dict
    }
}
