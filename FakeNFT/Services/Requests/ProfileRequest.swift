import Foundation

struct ProfileRequest: NetworkRequest {
    let token: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(token)")
    }
    var dto: Dto?
}
