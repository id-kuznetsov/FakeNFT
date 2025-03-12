import Foundation

struct ProfileRequest: NetworkRequest {
    let endpoint: URL?
    let dto: Dto?
    
    init() {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        self.dto = nil
    }
}
