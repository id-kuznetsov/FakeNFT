import Foundation

protocol ProfileEditingViewModel {
    var avatar: Observable<URL?> { get }
    var name: Observable<String?> { get }
    var description: Observable<String?> { get }
    var website: Observable<String?> { get }
    
    var nameWarning: Observable<ProfileEditingWarning?> { get }
    var descriptionWarning: Observable<ProfileEditingWarning?> { get }
    var websiteWarning: Observable<ProfileEditingWarning?> { get }
    
    func viewWillDismiss()
    func avatarButtonDidTap()
    func nameDidChange(editedName: String)
    func descriptionDidChange(editedDescription: String)
    func websiteDidChange(editedWebsite: String)
}

struct ProfileEditingWarning {
    let message: String
}
