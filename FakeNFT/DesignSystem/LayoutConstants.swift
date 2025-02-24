//
//  LayoutConstants.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 23.02.2025.
//

import Foundation

enum LayoutConstants {
    /// Общие константы для всех экранов
    enum Common {
        static let baseWidth: CGFloat = 375
        static let cornerRadiusRegular: CGFloat = 10
        static let cornerRadiusMedium: CGFloat = 12

        enum Margin {
            static let small: CGFloat = 8
            static let regular: CGFloat = 10
            static let medium: CGFloat = 16
            static let large: CGFloat = 24
        }
    }

    enum CollectionsScreen {
        static let rowHeight: CGFloat = 187
        static let coverImageHeight: CGFloat = 140
        static let cellSpacing: CGFloat = 4
        static let cellMargin: CGFloat = 21
        static let tableMargin: CGFloat = 20
    }

    enum CollectionScreen {
        static let numberOfSections: Int = 1

        enum CollectionParams {
            static let cellCount: CGFloat = 3
            static let topInset: CGFloat = LayoutConstants.Common.Margin.large
            static let bottomInset: CGFloat = LayoutConstants.Common.Margin.large
            static let leftInset: CGFloat = LayoutConstants.Common.Margin.medium
            static let rightInset: CGFloat = LayoutConstants.Common.Margin.medium
            static let cellSpacing: CGFloat = LayoutConstants.Common.Margin.regular
            static let cellHeight: CGFloat = 192
            static let lineSpacing: CGFloat = LayoutConstants.Common.Margin.medium
            static let paddingWidth = leftInset + rightInset + (cellCount - 1) * cellSpacing
        }

        enum Header {
            static let coverImageHeight: CGFloat = 310
            static let aboutVStackWidth: CGFloat = 341
        }

        enum Cell {
            static let imageHeight: CGFloat = 108
            static let buttonHeight: CGFloat = 40
            static let buttonWidth: CGFloat = 40
            static let marginSmall: CGFloat = 4
            static let marginRegular: CGFloat = 8
            static let marginMedium: CGFloat = 12
            static let marginLarge: CGFloat = 20
        }
    }
}
