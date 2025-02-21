import Foundation

protocol ProfileViewModel {
    var profile: Profile? { get }
    
    func fetchProfile()
}

