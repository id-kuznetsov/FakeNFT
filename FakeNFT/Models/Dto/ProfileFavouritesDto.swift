import Foundation

struct ProfileFavouritesDto: Dto {
    var likes: [String]
    
    private enum Params: String {
        case likes
    }
    
    func asDictionary() -> [String : String] {
        let likesValue = likes.isEmpty ? "null" : likes.joined(separator: ", ")
        return [Params.likes.rawValue: likesValue]
    }
}
