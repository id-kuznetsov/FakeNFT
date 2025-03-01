//
//  RatingButton.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 21.02.2025.
//

import UIKit

final class RatingButton: UIButton {
    private let maxStars = 5
    private var rating: Int = 0 {
        didSet {
            updateTitle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setTitleColor(.ypYellowUniversal, for: .normal)
        titleLabel?.font = .caption2
    }

    func configure(rating: Int) {
        self.rating = min(max(rating, 0), maxStars)
    }

    private func updateTitle() {
        let stars = (0..<maxStars).map { $0 < rating ? "★" : "☆" }.joined(separator: "")
        setTitle(stars, for: .normal)
    }
}
