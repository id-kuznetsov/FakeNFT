//
//  ShimmerView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 19.02.2025.
//

import UIKit

final class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()
    private var isAnimating = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

    private func setupShimmer() {
        self.backgroundColor = .lightGray.withAlphaComponent(0.5)
        gradientLayer.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.masksToBounds = true
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0, 0.1, 0.3]

        self.layer.addSublayer(gradientLayer)
    }

    func startShimmerAnimation() {
        guard !isAnimating else { return }

        isAnimating = true

        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1.0
        animation.fromValue = [0, 0.1, 0.3]
        animation.toValue = [0, 0.8, 1]
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }

    func stopShimmerAnimation() {
        guard isAnimating else { return }

        isAnimating = false
        gradientLayer.removeAnimation(forKey: "shimmerAnimation")
    }
}

extension UIView {
    func showShimmerAnimation() {
        let shimmerView = ShimmerView(frame: self.bounds)
        shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(shimmerView)
        shimmerView.startShimmerAnimation()
    }

    func hideShimmerAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }

            for subview in subviews where subview is ShimmerView {
                subview.removeFromSuperview()
            }
        }
    }
}
