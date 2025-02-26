//
//  TopAlignedImageView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 24.02.2025.
//

import UIKit

class TopAlignedImageView: UIImageView {
    func adjustContentMode() {
        guard let image = self.image else { return }

        let imageAspect = image.size.width / image.size.height
        let viewAspect = bounds.width / bounds.height

        if viewAspect < imageAspect {
            self.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        } else {
            let scale = bounds.width / image.size.width
            let scaledHeight = image.size.height * scale
            let visibleRatio = bounds.height / scaledHeight
            self.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: visibleRatio)
        }

        layoutSubviews()
    }

    func resetContentMode() {
        self.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        layoutSubviews()
    }
}
