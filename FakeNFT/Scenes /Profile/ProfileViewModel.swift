import Foundation

protocol ProfileViewModel {
    var profile: Profile { get }
    var isLoading: Bool { get }
    
    func fetchProfile()
}

