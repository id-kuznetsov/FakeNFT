import UIKit

extension UIFont {
    // Ниже приведены примеры шрифтов, настоящие шрифты надо взять из фигмы

    // Headline Fonts
    static var headline1 = UIFont.systemFont(ofSize: 34, weight: .bold)
    static var headline2 = UIFont.systemFont(ofSize: 28, weight: .bold)
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)
    static var headline5 = UIFont.systemFont(ofSize: 17, weight: .semibold)

    // Body Fonts
    static var bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)
    static var bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)
    static var bodyMedium = UIFont.systemFont(ofSize: 10, weight: .medium)

    // Caption Fonts
    static var caption1 = UIFont.systemFont(ofSize: 15, weight: .regular)
    static var caption2 = UIFont.systemFont(ofSize: 13, weight: .regular)
    static var caption3 = UIFont.systemFont(ofSize: 10, weight: .regular)
    static var caption4 = UIFont.systemFont(ofSize: 10, weight: .medium)
}
