//
//  CatalogCollectionGeometricParams.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 22.02.2025.
//

import Foundation

struct CatalogCollectionGeometricParams {
    let cellCount: CGFloat
    let topInset: CGFloat
    let bottomInset: CGFloat
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let cellHeight: CGFloat
    let paddingWidth: CGFloat
    let lineSpacing: CGFloat

    init(
        cellCount: CGFloat,
        topInset: CGFloat,
        bottomInset: CGFloat,
        leftInset: CGFloat,
        rightInset: CGFloat,
        cellSpacing: CGFloat,
        cellHeight: CGFloat,
        lineSpacing: CGFloat
    ) {
        self.cellCount = cellCount
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.cellHeight = cellHeight
        self.lineSpacing = lineSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
