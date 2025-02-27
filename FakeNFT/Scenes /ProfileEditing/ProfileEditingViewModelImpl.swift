import UIKit

protocol ProfileEditingDelegate: AnyObject {
    func didEndEditingProfile(_ profileEditingDto: ProfileEditingDto)
}

final class ProfileEditingViewModelImpl: ProfileEditingViewModel {
    
    // MARK: - Public Properties
    
    weak var delegate: ProfileEditingDelegate?
    
    var avatar: Observable<String>
    var name: Observable<String>
    var description: Observable<String>
    var website: Observable<String>
    
    // MARK: - Private Properties
    
    private let coordinator: ProfileCoordinator
    
    // MARK: - Init
    
    init(profile: Profile, coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        avatar = Observable(value: profile.avatar)
        name = Observable(value: profile.name)
        description = Observable(value: profile.description)
        website = Observable(value: profile.website)
    }
    
    // MARK: - Public Properties
    
    func viewWillDisappear() {
        let dto = ProfileEditingDto(
            avatar: avatar.value,
            name: name.value,
            description: description.value,
            website: website.value
        )
        delegate?.didEndEditingProfile(dto)
    }
    
    func avatarButtonDidTap() {
        coordinator.avatarEditingScene(avatar: avatar.value)
    }
    
    func nameDidChange(updatedName: String) {
        name.value = updatedName
    }
    
    func descriptionDidChange(updatedDescription: String) {
        description.value = updatedDescription
    }
    
    func websiteDidChange(updatedWebsite: String) {
        website.value = updatedWebsite
    }
}
