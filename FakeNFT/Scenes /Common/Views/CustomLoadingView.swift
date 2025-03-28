//
//  CustomLoadingView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 03.03.2025.
//

import UIKit

class CustomLoadingView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = .icSpinner
        view.tintColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = Double.pi * 2
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }

    func stopAnimating() {
        imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
