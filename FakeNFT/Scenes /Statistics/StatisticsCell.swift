//
//  StatisticsCell.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import UIKit

final class StatisticsCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Private properties
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = StatisticsConstants.Common.cornerRadiusHight
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .ypBlack
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .ypBlack
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = StatisticsConstants.Common.cornerRadiusMedium
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
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
            
            containerView.leadingAnchor.constraint(
                equalTo: indexLabel.trailingAnchor,
                constant: StatisticsConstants.StatisticsVc.TableViewParams.sideMarginFromEdges
            ),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -StatisticsConstants.StatisticsVc.TableViewParams.containerViewRightInset
            ),
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: StatisticsConstants.StatisticsVc.TableViewParams.containerViewTop
            ),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -StatisticsConstants.StatisticsVc.TableViewParams.containerViewBottom
            ),
            containerView.heightAnchor.constraint(
                equalToConstant: StatisticsConstants.StatisticsVc.TableViewParams.containerViewHight
            ),
            
            avatarImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: StatisticsConstants.StatisticsVc.TableViewParams.sideMarginFromEdges
            ),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: StatisticsConstants.StatisticsVc.TableViewParams.avatarWidth
            ),
            avatarImageView.heightAnchor.constraint(
                equalToConstant: StatisticsConstants.StatisticsVc.TableViewParams.avatarHeight
            ),
            
            nameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: StatisticsConstants.StatisticsVc.TableViewParams.nameLabelLeftInset
            ),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: ratingLabel.leadingAnchor,
                constant: -StatisticsConstants.StatisticsVc.TableViewParams.sideMarginFromEdges
            ),
            
            ratingLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -StatisticsConstants.StatisticsVc.TableViewParams.sideMarginFromEdges
            ),
            ratingLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    // MARK: - Public methods
    func configure(with user: User, index: Int) {
        indexLabel.text = "\(index + 1)"
        nameLabel.text = user.name
        ratingLabel.text = "\(user.rating)"
        
        let placeholderImage = UIImage.profileTab?.withTintColor(.ypGrayUniversal, renderingMode: .alwaysOriginal)
        
        if let avatarURLString = user.avatar, let url = URL(string: avatarURLString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
    }
}
