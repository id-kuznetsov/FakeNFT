//
//  StatisticsConstants.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 27.02.2025.
//

import Foundation

enum StatisticsConstants {
    // General constants for Statistics
    enum Common {
        static let zeroConstant: CGFloat = 0
        static let baseWidth: CGFloat = 375
        static let cornerRadiusRegular: CGFloat = 10
        static let cornerRadiusMedium: CGFloat = 12
        static let cornerRadiusHight: CGFloat = 14
        static let cornerRadiusXHight: CGFloat = 16
        static let cornerRadiusBig: CGFloat = 34
        
        enum Margin {
            static let xxSmall: CGFloat = 2
            static let xSmall: CGFloat = 4
            static let small: CGFloat = 8
            static let regular: CGFloat = 10
            static let xRegular: CGFloat = 12
            static let medium: CGFloat = 16
            static let large: CGFloat = 24
        }
        
        enum Spacing {
            static let regular: CGFloat = 8
        }
    }
    
    enum StatisticsVc {
        enum TableViewParams {
            static let heightForRow: CGFloat = 88
            static let sideMarginFromEdges = Common.Margin.medium
            static let avatarHeight: CGFloat = 28
            static let avatarWidth: CGFloat = 28
            static let nameLabelLeftInset = Common.Margin.small
            static let containerViewTop = Common.Margin.xSmall
            static let containerViewBottom = Common.Margin.xSmall
            static let containerViewHight: CGFloat = 80
            static let containerViewRightInset: CGFloat = 3
            static let containerViewtopInset = Common.zeroConstant
            static let containerViewleftInset = Common.zeroConstant
            static let containerViewbottomInset = Common.zeroConstant
        }
    }
    
    enum UserCardVc {
        enum MainScreen {
            static let nftButtonSpacing = Common.Spacing.regular
            static let avatarLeftInset = Common.Margin.medium
            static let avatarWidth: CGFloat = 70
            static let nameLabelLeftInset = Common.Margin.medium
            static let descriptionRightInset = Common.Margin.medium
            static let descriptionTopInset: CGFloat = 20
            static let webViewButtonHeight: CGFloat = 40
            static let webViewButtonTopInset: CGFloat = 28
            static let nftButtonTopInset: CGFloat = 56
        }
    }
    
    enum UserNftVc {
        enum MainScreen {
            static let cellHeight: CGFloat = 192
            static let topEdgeInset: CGFloat = 20
            static let rightEdgeInset = Common.zeroConstant
            static let leftEdgeInset = Common.zeroConstant
            static let bottomEdgeInset = Common.zeroConstant
            static let verticalCollectionSpacing = Common.zeroConstant
            static let sideCollectionMargin = Common.Margin.medium
            static let verticalCellsSpacing: CGFloat = 28
            static let horizontalCellsSpacing = Common.Margin.regular
            static let cellsInRow: CGFloat = 3
            static let nftImageWidth: CGFloat = 108
            static let likeButtonTop = Common.Margin.xRegular
            static let likeButtonRight = Common.Margin.xRegular
            static let likeButtonWidth: CGFloat = 18
            static let likeButtonHeight: CGFloat = 16
            static let backViewTop = Common.Spacing.regular
            static let ratingViewWidth: CGFloat = 68
            static let ratingViewHeight: CGFloat = 12
            static let nftNameLabelTop: CGFloat = 5
            static let nameLabelHeight: CGFloat = 22
            static let priceLabelTop: CGFloat = 4
            static let priceLabelHeight: CGFloat = 12
            static let cartButtonWidth: CGFloat = 40
        }
    }
}

