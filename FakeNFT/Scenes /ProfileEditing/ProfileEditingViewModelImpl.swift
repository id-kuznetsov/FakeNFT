import UIKit

protocol ProfileEditingViewModelImplDelegate: AnyObject {
    func didEndEditingProfile(with result: Result<Profile, Error>)
}

final class ProfileEditingViewModelImpl: ProfileEditingViewModel {
    weak var delegate: ProfileEditingViewModelImplDelegate?
    
    var avatar: Observable<URL?>
    var name: Observable<String?>
    var description: Observable<String?>
    var website: Observable<String?>
    
    var nameWarning: Observable<ProfileEditingWarning?>
    var descriptionWarning: Observable<ProfileEditingWarning?>
    var websiteWarning: Observable<ProfileEditingWarning?>
    
    private let coordinator: ProfileCoordinator
    
    private let profile: Profile
    private let maxNameLength = 35
    private let maxDescriptionLength = 150
    
    init(profile: Profile, coordinator: ProfileCoordinator) {
        self.profile = profile
        self.coordinator = coordinator
        
        avatar = Observable(value: URL(string: profile.avatar))
        name = Observable(value: profile.name)
        description = Observable(value: profile.description)
        website = Observable(value: profile.website)
        
        nameWarning = Observable(value: nil)
        descriptionWarning = Observable(value: nil)
        websiteWarning = Observable(value: nil)
    }
    
    func viewWillDismiss() {
        delegate?.didEndEditingProfile(with: .success(profile))
    }
    
    func avatarButtonDidTap() {
        
    }
    
    func nameDidChange(editedName: String) {
        let isValid = validateStringLength(text: editedName, length: maxNameLength)
        if isValid {
            name.value = editedName
            nameWarning.value = nil
        } else {
            nameWarning.value = ProfileEditingWarning(message: "Name is too long or empty.")
        }
    }
    
    func descriptionDidChange(editedDescription: String) {
        let isValid = validateStringLength(text: editedDescription, length: maxDescriptionLength)
        if isValid {
            description.value = editedDescription
            descriptionWarning.value = nil
        } else {
            descriptionWarning.value = ProfileEditingWarning(message: "Description is too long or empty.")
        }
    }
    
    func websiteDidChange(editedWebsite: String) {
        if isValidUrl(urlString: editedWebsite) {
            website.value = editedWebsite
            websiteWarning.value = nil
        } else {
            websiteWarning.value = ProfileEditingWarning(message: "Invalid website URL.")
        }
    }
    
    private func validateStringLength(text: String, length: Int) -> Bool {
        return text.count <= length && !text.isEmpty
    }
    
    private func isValidUrl(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}
