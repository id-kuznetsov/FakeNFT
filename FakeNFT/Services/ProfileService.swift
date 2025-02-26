import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func fetchProfile(_ completion: @escaping ProfileCompletion)
    func updateProfile(field: ProfileUpdateField, value: String, _ completion: @escaping ProfileCompletion)
}

enum ProfileUpdateField {
    case avatar, name, description, website
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private var fetchProfileTask: NetworkTask?
    private var networkTasks: [ProfileUpdateField: NetworkTask] = [:]
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(_ completion: @escaping ProfileCompletion) {
        fetchProfileTask?.cancel()
        let request = ProfileRequest()
        
        fetchProfileTask = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.fetchProfileTask = nil
            completion(result)
        }
    }
    
    func updateProfile(field: ProfileUpdateField, value: String, _ completion: @escaping ProfileCompletion) {
        networkTasks[field]?.cancel()
        
        let dto: ProfileEditingDto
        switch field {
        case .avatar:
            dto = ProfileEditingDto(avatar: value)
        case .name:
            dto = ProfileEditingDto(name: value)
        case .description:
            dto = ProfileEditingDto(description: value)
        case .website:
            dto = ProfileEditingDto(website: value)
        }
        
        let request = ProfileEditingRequest(dto: dto)
        networkTasks[field] = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.networkTasks[field] = nil
            completion(result)
        }
    }
}
