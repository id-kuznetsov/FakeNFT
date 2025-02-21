import Foundation

protocol ProfileViewModel {
    var profile: Observable<Profile?> { get }
    var errorModel: Observable<ErrorModel?> { get }
    
    func fetchProfile()
}

