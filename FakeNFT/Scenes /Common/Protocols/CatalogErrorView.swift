import UIKit

protocol CatalogErrorView {}

extension CatalogErrorView where Self: UIViewController {
    func showError(
        style: UIAlertController.Style = .alert,
        title: String? = L10n.Alert.Title.networkError,
        error: Error,
        buttons: [AlertButton]
    ) {
        let message: String

        switch error {
        case let networkClientError as NetworkClientError:
            switch networkClientError {
            case .httpStatusCode(404):
                message = L10n.Alert.Message.serverNotFound
            case .httpStatusCode(403):
                message = L10n.Alert.Message.sslError
            case .urlSessionError:
                message = L10n.Alert.Message.timeoutError
            default:
                message = L10n.Alert.Message.network
            }
        case is NetworkMonitorError:
            message = L10n.Alert.Message.networkError
        case is WebViewError:
            message = L10n.Alert.Message.apiBug
        default:
            message = L10n.Alert.Message.unknown
        }

        let model = AlertModel(
            title: title,
            message: message,
            buttons: buttons,
            style: .alert
        )
        CatalogAlertPresenter.showAlert(on: self, model: model)
    }
}
