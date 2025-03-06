import UIKit

struct AlertPresenter {
    static func showAlert(
        on viewController: UIViewController,
        model: AlertModel
    ) {
        showBasicAlert(
            on: viewController,
            title: model.title,
            message: model.message,
            buttons: model.buttons,
            style: model.style,
            image: nil
        )
    }

    static func showChangeNftRatingView(
        on viewController: UIViewController,
        model: AlertModel,
        image: UIImage
    ) {
        showBasicAlert(
            on: viewController,
            title: model.title,
            message: model.message,
            buttons: model.buttons,
            style: model.style,
            image: image
        )
    }

    private static func showBasicAlert(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        buttons: [AlertButton],
        style: AlertStyle,
        image: UIImage?
    ) {
        switch style {
        case .alert, .filter:
            guard !buttons.isEmpty else {
                print("⚠️ AlertPresenter: передан пустой массив кнопок – алерт не будет показан.")
                return
            }

            showRegularAlertController(
                on: viewController,
                title: title,
                message: message,
                buttons: buttons,
                style: UIAlertController.Style(from: style)
            )
        case .nftRating:
            showRatingAlertController(
                on: viewController,
                image: image
            )
        }
    }

    private static func showRegularAlertController(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        buttons: [AlertButton],
        style: UIAlertController.Style
    ) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)

        for button in buttons {
            let action = UIAlertAction(
                title: button.title,
                style: UIAlertAction.Style(from: button.style),
                handler: { _ in button.action() }
            )
            alert.addAction(action)
        }

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }

    private static func showRatingAlertController(
        on viewController: UIViewController,
        image: UIImage?
    ) {
        let alert = NFTRatingAlertViewController(image: image)

        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }

}

extension UIAlertAction.Style {
    init(from style: AlertButtonStyle) {
        switch style {
        case .default:
            self = .default
        case .cancel:
            self = .cancel
        case .destructive:
            self = .destructive
        }
    }
}

extension UIAlertController.Style {
    init(from style: AlertStyle) {
        switch style {
        case .alert:
            self = .alert
        case .filter:
            self = .actionSheet
        case .nftRating:
            self = .alert
        }
    }
}
