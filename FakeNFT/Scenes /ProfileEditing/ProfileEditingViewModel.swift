import Foundation

protocol ProfileEditingViewModel {
    var avatar: Observable<String> { get }
    var name: Observable<String> { get }
    var description: Observable<String> { get }
    var website: Observable<String> { get }
    var nameWarning: Observable<ProfileEditingWarning?> { get }
    var descriptionWarning: Observable<ProfileEditingWarning?> { get }
    var websiteWarning: Observable<ProfileEditingWarning?> { get }
    var errorModel: Observable<ErrorModel?> { get }
    
    func viewWillDisappear()
    func avatarUpdateAction(updatedAvatar: String)
    func avatarRemoveAction()
    func didFailImageLoading()
    func nameDidChange(updatedName: String)
    func descriptionDidChange(updatedDescription: String)
    func websiteDidChange(updatedWebsite: String)
}
