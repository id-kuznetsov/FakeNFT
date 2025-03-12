import Foundation

protocol ProfileEditingDelegate: AnyObject {
    func didEndEditingProfile(_ profileEditingDto: ProfileEditingDto)
}

final class ProfileEditingViewModelImpl: ProfileEditingViewModel {
    
    // MARK: - Constants
    
    private let maxNameLength = 30
    private let maxDescriptionLength = 150
    
    // MARK: - Public Properties
    
    weak var delegate: ProfileEditingDelegate?
    
    var avatar: Observable<String>
    var name: String
    var description: String
    var website: String
    
    var nameWarning = Observable<ProfileEditingWarning?>(value: nil)
    var descriptionWarning = Observable<ProfileEditingWarning?>(value: nil)
    var websiteWarning = Observable<ProfileEditingWarning?>(value: nil)
    
    var errorModel: Observable<ErrorModel?>
    
    // MARK: - Private Properties
    
    private let coordinator: ProfileCoordinator
    private let profile: Profile
    
    // MARK: - Init
    
    init(profile: Profile, coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        self.profile = profile
        avatar = Observable(value: profile.avatar)
        name = profile.name
        description = profile.description
        website = profile.website
        errorModel = Observable(value: nil)
    }
    
    // MARK: - Public Properties
    
    func viewWillDisappear() {
        // Name can't be empty
        let dtoName = name.isEmpty ? profile.name : name
        let dtoWebsite = websiteWarning.value == nil ? website : ""
        
        let dto = ProfileEditingDto(
            avatar: avatar.value,
            name: dtoName,
            description: description,
            website: dtoWebsite
        )
        
        delegate?.didEndEditingProfile(dto)
    }
    
    func avatarUpdateAction(updatedAvatar: String) {
        guard let url = URL(string: updatedAvatar) else {
            didFailImageLoading()
            return
        }
        
        url.isReachable { [weak self] isReachable in
            if isReachable {
                self?.avatar.value = updatedAvatar
            } else {
                self?.didFailImageLoading()
            }
        }
    }
    
    func avatarRemoveAction() {
        avatar.value = ""
    }
    
    func didFailImageLoading() {
        avatar.value = ""
        errorModel.value = ErrorModel(
            message: L10n.ProfileEditingAlert.imageLoadingError,
            actionText: L10n.ProfileEditingAlert.okAction,
            action: {}
        )
    }
    
    func shouldChangeName(updatedName: String) -> Bool {
        guard updatedName.count <= maxNameLength else {
            nameWarning.value = .nameLimit(maxNameLength)
            return false
        }
        
        name = updatedName
        nameWarning.value = nil
        if updatedName.isEmpty {
            nameWarning.value = .emptyName
        }
        
        return true
    }
    
    func shouldChangeDescription(updatedDescription: String) -> Bool {
        guard updatedDescription.count <= maxDescriptionLength else {
            descriptionWarning.value = .descriptionLimit(maxDescriptionLength)
            return false
        }
        
        description = updatedDescription
        descriptionWarning.value = nil
        return true
    }
    
    func shouldChangeWebsite(updatedWebsite: String) -> Bool {
        website = updatedWebsite
        
        guard let url = URL(string: updatedWebsite) else {
            websiteWarning.value = updatedWebsite.isEmpty ? nil : .incorrectWebsite
            return true
        }
        
        url.isReachable { [weak self] isReachable in
            if isReachable {
                self?.websiteWarning.value = nil
            } else {
                self?.websiteWarning.value = .incorrectWebsite
            }
        }
        return true
    }
}
