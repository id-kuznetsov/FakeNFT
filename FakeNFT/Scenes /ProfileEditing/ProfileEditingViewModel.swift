import Foundation

protocol ProfileEditingViewModel {
    var avatar: Observable<String> { get }
    var name: String { get }
    var description: String { get }
    var website: String { get }
    var nameWarning: Observable<ProfileEditingWarning?> { get }
    var descriptionWarning: Observable<ProfileEditingWarning?> { get }
    var websiteWarning: Observable<ProfileEditingWarning?> { get }
    var errorModel: Observable<ErrorModel?> { get }

    func viewWillDisappear()
    func avatarUpdateAction(updatedAvatar: String)
    func avatarRemoveAction()
    func didFailImageLoading()

    @discardableResult
    func shouldChangeName(updatedName: String) -> Bool

    @discardableResult
    func shouldChangeDescription(updatedDescription: String) -> Bool

    @discardableResult
    func shouldChangeWebsite(updatedWebsite: String) -> Bool
}
