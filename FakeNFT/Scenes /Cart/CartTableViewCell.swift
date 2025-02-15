//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 15.02.2025.
//

import UIKit

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties

    
    // MARK: - Private Properties
    
    
    // MARK: - Initialisers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypRedUniversal
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    
}
