import UIKit

protocol CatalogLoadingView {
    func showLoading()
    func hideLoading()
}

extension CatalogLoadingView where Self: UIViewController {
    var activityIndicator: CustomLoadingView {
        let tag = 9999
        if let existingIndicator = view.viewWithTag(tag) as? CustomLoadingView {
            return existingIndicator
        }

        let customLoadingView = CustomLoadingView()
        customLoadingView.tag = tag
        customLoadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customLoadingView)

        NSLayoutConstraint.activate([
            customLoadingView.widthAnchor.constraint(equalToConstant: 80),
            customLoadingView.heightAnchor.constraint(equalToConstant: 80),
            customLoadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customLoadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return customLoadingView
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
