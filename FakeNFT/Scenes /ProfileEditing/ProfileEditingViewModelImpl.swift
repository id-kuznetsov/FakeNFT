import UIKit

protocol ProfileEditingDelegate: AnyObject {
    func didEndEditingProfile(_ profileEditingDto: ProfileEditingDto)
}

final class ProfileEditingViewModelImpl: ProfileEditingViewModel {
    
    // MARK: - Public Properties
    
    weak var delegate: ProfileEditingDelegate?
    var profileEditingDto: Observable<ProfileEditingDto>
    
    // MARK: - Private Properties
    
    private let coordinator: ProfileCoordinator
    
    private var avatar: String { 
        get { profileEditingDto.value.avatar }
        set { profileEditingDto.value.avatar = newValue }
    }
    
    private var name: String {
        get { profileEditingDto.value.name }
        set { profileEditingDto.value.name = newValue }
    }
    
    private var description: String {
        get { profileEditingDto.value.description }
        set { profileEditingDto.value.description = newValue }
    }
    
    private var website: String {
        get { profileEditingDto.value.website }
        set { profileEditingDto.value.website = newValue }
    }
    
    // MARK: - Init
    
    init(profile: Profile, coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        let dto = ProfileEditingDto(
            avatar: profile.avatar,
            name: profile.name,
            description: profile.description,
            website: profile.website
        )
        profileEditingDto = Observable(value: dto)
    }
    
    // MARK: - Public Properties
    
    func viewWillDisappear() {
        delegate?.didEndEditingProfile(profileEditingDto.value)
    }
    
    func avatarButtonDidTap() {
        coordinator.avatarEditingScene(avatar: avatar)
    }
    
    func nameDidChange(updatedName: String) {
        name = updatedName
    }
    
    func descriptionDidChange(updatedDescription: String) {
        description = updatedDescription
    }
    
    func websiteDidChange(updatedWebsite: String) {
        website = updatedWebsite
    }
}
