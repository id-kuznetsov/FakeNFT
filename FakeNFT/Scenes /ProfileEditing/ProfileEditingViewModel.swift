import Foundation

protocol ProfileEditingViewModel {
    var profileEditingDto: Observable<ProfileEditingDto> { get }
    
    func viewWillDisappear()
    func avatarButtonDidTap()
    func nameDidChange(updatedName: String)
    func descriptionDidChange(updatedDescription: String)
    func websiteDidChange(updatedWebsite: String)
}

struct ProfileEditingWarning {
    let message: String
}
