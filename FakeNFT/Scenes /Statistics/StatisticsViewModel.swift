//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import UIKit

final class StatisticsViewModel {
    
    // MARK: - Properties
    var users: [UserStatistics] = [
        UserStatistics(avatar: UIImage(named: "mock1"), name: "Alex", rating: 112),
        UserStatistics(avatar: UIImage(named: "mock2"), name: "Bill", rating: 15),
        UserStatistics(avatar: UIImage(named: "mock3"), name: "Alla", rating: 72),
        UserStatistics(avatar: UIImage(named: "mock4"), name: "Mads", rating: 33),
        UserStatistics(avatar: UIImage(named: "mock5"), name: "Timothée", rating: 51),
        UserStatistics(avatar: UIImage(named: "mock6"), name: "Lea", rating: 23),
        UserStatistics(avatar: UIImage(named: "mock7"), name: "Eric", rating: 19)
    ]
}
