import Foundation

protocol ProfileViewModel {
    var profile: Observable<ProfileDTO?> { get }
    var isLoading: Observable<Bool> { get }
    var errorModel: Observable<ErrorModel?> { get }

    func viewWillAppear()
    func editButtonDidTap()
    func myNftsCellDidSelect()
    func favouritesCellDidSelect()
    func aboutDeveloperCellDidSelect()
    func linkButtonDidTap()
}
