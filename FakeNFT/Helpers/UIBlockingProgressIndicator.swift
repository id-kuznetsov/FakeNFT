//
//  UIBlockingProgressIndicator.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 25.02.2025.
//

import UIKit

final class UIBlockingProgressIndicator {

    private static var overlayView: UIView?
    private static var activityIndicator: UIActivityIndicatorView?

    private static var window: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    static func show() {
        guard let window = window else { return }
        window.isUserInteractionEnabled = false

        let overlay = UIView(frame: window.bounds)
        overlay.accessibilityIdentifier = "ProgressIndicator"
        overlay.isUserInteractionEnabled = false
        overlay.backgroundColor = .clear

        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .ypBlack
        indicator.startAnimating()

        overlay.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])

        window.addSubview(overlay)

        overlayView = overlay
        activityIndicator = indicator
    }

    static func dismiss() {
        guard let window = window else { return }
        window.isUserInteractionEnabled = true

        activityIndicator?.stopAnimating()
        overlayView?.removeFromSuperview()

        overlayView = nil
        activityIndicator = nil
    }
}
