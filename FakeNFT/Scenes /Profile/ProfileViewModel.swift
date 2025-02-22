import Foundation

protocol ProfileViewModel {
    var profile: Observable<Profile?> { get }
    var errorModel: Observable<ErrorModel?> { get }
    
    func fetchProfile()
    func presentProfileEditingScreen()
    func pushMyNftsScreen()
    func pushFavouritesScreen()
    func pushAboutDeveloperScreen()
    func pushUserWebsiteScreen()
}

