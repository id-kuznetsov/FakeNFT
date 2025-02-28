import UIKit

protocol ProfileEditingDelegate: AnyObject {
    func didEndEditingProfile(_ profileEditingDto: ProfileEditingDto)
}

enum ProfileEditingWarning {
    case emptyName
    case nameLimit(Int)
    case descriptionLimit(Int)
    case incorrectWebsite
    
    var title: String {
        switch self {
        case .emptyName:
            L10n.ProfileEditing.emptyNameWarning
        case .nameLimit(let limit), .descriptionLimit(let limit):
            L10n.ProfileEditing.limitWarning(limit)
        case .incorrectWebsite:
            L10n.ProfileEditing.incorrectWebsiteWarning
        }
    }
}

final class ProfileEditingViewModelImpl: ProfileEditingViewModel {
    
    // MARK: - Constants
    
    private let maxNameLength = 30
    private let maxDescriptionLength = 150
    
    // MARK: - Public Properties
    
    weak var delegate: ProfileEditingDelegate?
    
    var avatar: Observable<String>
    var name: Observable<String>
    var description: Observable<String>
    var website: Observable<String>
    
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
        name = Observable(value: profile.name)
        description = Observable(value: profile.description)
        website = Observable(value: profile.website)
        errorModel = Observable(value: nil)
    }
    
    // MARK: - Public Properties
    
    func viewWillDisappear() {
        // Name can't be empty
        let dtoName = name.value.isEmpty ? profile.name : name.value
        let dtoWebsite = websiteWarning.value == nil ? website.value : ""
        
        let dto = ProfileEditingDto(
            avatar: avatar.value,
            name: dtoName,
            description: description.value,
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
            message: "Невозможно изменить изображение",
            actionText: "OK",
            action: {}
        )
    }
    
    func nameDidChange(updatedName: String) {
        if updatedName.count <= maxNameLength {
            name.value = updatedName
            nameWarning.value = nil
            if updatedName.isEmpty {
                nameWarning.value = .emptyName
            }
        } else {
            nameWarning.value = .nameLimit(maxNameLength)
        }
    }
    
    func descriptionDidChange(updatedDescription: String) {
        if updatedDescription.count <= maxDescriptionLength {
            description.value = updatedDescription
            descriptionWarning.value = nil
        } else {
            descriptionWarning.value = .descriptionLimit(maxDescriptionLength)
        }
    }
    
    func websiteDidChange(updatedWebsite: String) {
        website.value = updatedWebsite
        
        guard let url = URL(string: updatedWebsite) else {
            websiteWarning.value = updatedWebsite.isEmpty ? nil : .incorrectWebsite
            return
        }
        
        url.isReachable { [weak self] isReachable in
            if isReachable {
                self?.websiteWarning.value = nil
            } else {
                self?.websiteWarning.value = .incorrectWebsite
            }
        }
    }
}
