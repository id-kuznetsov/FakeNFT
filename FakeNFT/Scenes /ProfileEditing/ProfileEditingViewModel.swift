import Foundation

protocol ProfileEditingViewModel {
    var avatarUrl: Observable<URL?> { get }
    var name: Observable<String> { get }
    var description: Observable<String> { get }
    var website: Observable<String> { get }
    func viewWillAppear()
    func viewWillDisappear()
}
