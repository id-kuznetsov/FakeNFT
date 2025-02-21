import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func fetchProfile(id: String, _ completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(id: String, _ completion: @escaping ProfileCompletion) {
        let nfts = [
            "b3907b86-37c4-4e15-95bc-7f8147a9a660",
            "d6a02bd1-1255-46cd-815b-656174c1d9c0",
            "9810d484-c3fc-49e8-bc73-f5e602c36b40",
            "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
            "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
            "1e649115-1d4f-4026-ad56-9551a16763ee",
            "7773e33c-ec15-4230-a102-92426a3a6d5a"
        ]
        
        let likes = [
            "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
            "b2f44171-7dcd-46d7-a6d3-e2109aacf520"
        ]
        
        let fakeProfile = Profile(name: "Студентус Практикумс",
                                  avatar: "https://photo.bank/1.png",
                                  description: "param1Value",
                                  website: "https://yandex.ru",
                                  nfts: nfts,
                                  likes: likes,
                                  id: ProfileConstants.id
        )
        
        completion(.success(fakeProfile))
    }
}

enum ProfileConstants {
    static let id = "1"
}
