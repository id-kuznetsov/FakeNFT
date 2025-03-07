//
//  UserNftCollectionCell.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 04.03.2025.
//

import UIKit

final class UserNftCollectionCell: UICollectionViewCell {
    
    // MARK: - Static properties
    static let identifier = "UserNftCollectionCell"
    
    // MARK: - Private properties
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = StatisticsConstants.Common.cornerRadiusMedium
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage.heart
        button.setImage(heartImage, for: .normal)
        button.tintColor = .ypWhite
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        let cartImage = UIImage(named: "ic.cart")
        button.setImage(cartImage, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backView = UIImageView()
    private lazy var ratingStackView = RatingStackView()
    private var nftId: String = ""
    
    var onLikeTapped: ((String) -> Void)?
    var onCartTapped: ((String) -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupUI() {
        contentView.backgroundColor = .ypWhite
        
        [nftImageView, likeButton, backView].forEach { element in
            contentView.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [ratingStackView, nftNameLabel, priceLabel, cartButton].forEach { element in
            backView.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.widthAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.nftImageWidth
            ),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            likeButton.topAnchor.constraint(
                equalTo: nftImageView.topAnchor,
                constant: StatisticsConstants.UserNftVc.MainScreen.likeButtonTop
            ),
            likeButton.trailingAnchor.constraint(
                equalTo: nftImageView.trailingAnchor,
                constant: -StatisticsConstants.UserNftVc.MainScreen.likeButtonRight
            ),
            likeButton.widthAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.likeButtonWidth
            ),
            likeButton.heightAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.likeButtonHeight
            ),
            
            backView.topAnchor.constraint(
                equalTo: nftImageView.bottomAnchor,
                constant: StatisticsConstants.UserNftVc.MainScreen.backViewTop
            ),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ratingStackView.topAnchor.constraint(equalTo: backView.topAnchor),
            ratingStackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            ratingStackView.heightAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.ratingViewHeight
            ),
            ratingStackView.widthAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.ratingViewWidth
            ),
            
            nftNameLabel.topAnchor.constraint(
                equalTo: ratingStackView.bottomAnchor,
                constant: StatisticsConstants.UserNftVc.MainScreen.nftNameLabelTop
            ),
            nftNameLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            nftNameLabel.heightAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.nameLabelHeight
            ),
            
            priceLabel.topAnchor.constraint(
                equalTo: nftNameLabel.bottomAnchor,
                constant: StatisticsConstants.UserNftVc.MainScreen.priceLabelTop
            ),
            priceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            priceLabel.heightAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.priceLabelHeight
            ),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.leadingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cartButton.widthAnchor.constraint(
                equalToConstant: StatisticsConstants.UserNftVc.MainScreen.cartButtonWidth
            ),
            cartButton.heightAnchor.constraint(equalTo: cartButton.widthAnchor)
        ])
        backView.isUserInteractionEnabled = true
    }
    
    @objc private func likeTapped() {
        onLikeTapped?(nftId)
    }
    
    @objc private func cartTapped() {
        onCartTapped?(nftId)
    }
    
    // MARK: - Public methods
    func configure(with model: Nft, isLiked: Bool, isInCart: Bool) {
        if let imageUrl = model.images.first {
            nftImageView.kf.setImage(with: imageUrl)
        } else {
            nftImageView.image = UIImage(named: "ic.close")
        }
        
        nftNameLabel.text = model.name
        ratingStackView.setRating(model.rating)
        priceLabel.text = "\(model.price) ETH"
        nftId = model.id
        likeButton.tintColor = isLiked ? .ypRedUniversal : .ypWhite
        
        let cartImage = isInCart ? UIImage(named: "ic.cart.fill") : UIImage(named: "ic.cart")
        cartButton.setImage(cartImage, for: .normal)
    }
}
