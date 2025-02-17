//
//  StatisticsCell.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import UIKit

final class StatisticsCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "StatisticsCell"
    
    // MARK: - UI Elements
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [indexLabel, containerView].forEach { element in
            contentView.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [avatarImageView, nameLabel, ratingLabel].forEach { element in
            containerView.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            ratingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            ratingLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func configure(with user: UserStatistics, index: Int) {
        indexLabel.text = "\(index + 1)"
        avatarImageView.image = user.avatar ?? UIImage(named: "ic.person.crop.circle.fill")
        nameLabel.text = user.name
        ratingLabel.text = "\(user.rating)"
    }
}
