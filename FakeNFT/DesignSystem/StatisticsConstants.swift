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
        static let baseWidth: CGFloat = 375
        static let cornerRadiusRegular: CGFloat = 10
        static let cornerRadiusMedium: CGFloat = 12
        static let cornerRadiusHight: CGFloat = 14
        static let cornerRadiusXHight: CGFloat = 16
        static let cornerRadiusBig: CGFloat = 34
        
        enum Margin {
            static let xSmall: CGFloat = 4
            static let small: CGFloat = 8
            static let regular: CGFloat = 10
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
}
