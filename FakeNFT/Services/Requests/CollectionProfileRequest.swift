import Foundation

struct CollectionProfileRequest: NetworkRequest {
    var profile: Profile?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        return profile == nil ? .get : .put
    }

    var dto: Dto? {
        guard
            let profile,
            let profileDTO = profile.toDTO()
        else {
            return nil
        }

        return UpdateProfileDto(profile: profileDTO)
    }
}

struct UpdateProfileDto: Dto {
    let profile: ProfileDTO

    enum CodingKeys: String, CodingKey {
        case likes
        case avatar
        case name
    }

    func asDictionary() -> [String: String] {
        [
            CodingKeys.likes.rawValue: profile.likes.joined(separator: ","),
            CodingKeys.avatar.rawValue: profile.avatar,
            CodingKeys.name.rawValue: profile.name
        ]
    }
}
