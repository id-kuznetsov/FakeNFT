import UIKit

extension UIImage {
    static var catalogTab = UIImage.init(systemName: "rectangle.stack.fill")?
        .resized(to: CGSize(width: 20, height: 22))
        .withRenderingMode(.alwaysTemplate)
    static var profileTab = UIImage.init(systemName: "person.crop.circle.fill")?
        .resized(to: CGSize(width: 22, height: 22))
        .withRenderingMode(.alwaysTemplate)
    static var checkmark = UIImage.init(systemName: "checkmark.circle.fill")
    static var heart = UIImage.init(systemName: "heart.fill")
    static var plus = UIImage.init(systemName: "plus.circle.fill")
    static var chevronLeft = UIImage.init(systemName: "chevron.left")
    static var chevronRight = UIImage.init(systemName: "chevron.right")
    static var squareAndPencil = UIImage.init(systemName: "square.and.pencil")
    static var star = UIImage.init(systemName: "star")
    static var starFill = UIImage.init(systemName: "star.fill")
    static var scribble = UIImage(systemName: "scribble")
}
