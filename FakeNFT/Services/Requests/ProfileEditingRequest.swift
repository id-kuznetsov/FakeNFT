import Foundation

final class ProfileEditingRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod
    let dto: Dto?

    init(dto: Dto?) {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        self.httpMethod = .put
        self.dto = dto
    }
}
