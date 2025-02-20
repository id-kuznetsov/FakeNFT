//
//  RatingStackView.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 19.02.2025.
//

import UIKit

final class RatingStackView: UIStackView {
    
    private var stars: [UIImageView] = []
    
    init(rating: Int = 0) {
        super.init(frame: .zero)
        setupView()
        setRating(rating)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        spacing = 2
        axis = .horizontal
        distribution = .fillEqually
        
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.contentMode = .scaleAspectFit
            star.tintColor = .ypLightGrey
            stars.append(star)
            addArrangedSubview(star)
        }
    }
    
    func setRating(_ rating: Int) {
        for (index, star) in stars.enumerated() {
            star.tintColor = index < rating ? .ypYellowUniversal : .ypLightGrey
        }
    }
}
