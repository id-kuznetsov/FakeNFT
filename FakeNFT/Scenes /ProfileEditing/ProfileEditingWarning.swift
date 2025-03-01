import Foundation

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
