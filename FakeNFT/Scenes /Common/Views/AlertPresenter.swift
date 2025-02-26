import UIKit

struct AlertPresenter {
    static func showAlert(on viewController: UIViewController, model: AlertModel) {
        showBasicAlert(
            on: viewController,
            title: model.title,
            message: model.message,
            buttons: model.buttons,
            style: UIAlertController.Style(from: model.style)
        )
    }

    private static func showBasicAlert(
        on viewController: UIViewController,
        title: String?,
        message: String?,
        buttons: [AlertButton],
        style: UIAlertController.Style
    ) {

        guard !buttons.isEmpty else {
            print("⚠️ AlertPresenter: передан пустой массив кнопок – алерт не будет показан.")
            return
        }

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)

        for button in buttons {
            let action = UIAlertAction(
                title: button.title,
                style: UIAlertAction.Style(from: button.style),
                handler: { _ in button.action?() }
            )
            alert.addAction(action)
        }

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
        case .actionSheet:
            self = .actionSheet
        }
    }
}
