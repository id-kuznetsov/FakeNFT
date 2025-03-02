import UIKit

protocol ErrorView {}

extension ErrorView where Self: UIViewController {
    func showError(
        style: UIAlertController.Style = .alert,
        title: String? = L10n.Alert.Title.networkError,
        error: Error,
        buttons: [AlertButton]
    ) {
        let message: String

        switch error {
        case let urlError as URLError:
            message = handleURLError(urlError)
        case is NetworkClientError:
            message = L10n.Alert.Message.network
        default:
            message = L10n.Alert.Message.unknown
        }

        let model = AlertModel(
            title: title,
            message: message,
            buttons: buttons,
            style: .alert
        )
        AlertPresenter.showAlert(on: self, model: model)
    }

    private func handleURLError(_ error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet:
            return L10n.Alert.Message.networkError
        case .timedOut:
            return L10n.Alert.Message.timeoutError
        case .secureConnectionFailed:
            return L10n.Alert.Message.sslError
        case .cannotFindHost:
            return L10n.Alert.Message.serverNotFound
        default:
            return L10n.Alert.Message.unknown
        }
    }
}
