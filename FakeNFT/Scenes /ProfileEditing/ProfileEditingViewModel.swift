import Foundation

protocol ProfileEditingViewModel {
    var avatar: Observable<String> { get }
    var name: Observable<String> { get }
    var description: Observable<String> { get }
    var website: Observable<String> { get }
    
    func viewWillDisappear()
    func avatarButtonDidTap()
    func nameDidChange(updatedName: String)
    func descriptionDidChange(updatedDescription: String)
    func websiteDidChange(updatedWebsite: String)
}

struct ProfileEditingWarning {
    let message: String
}
