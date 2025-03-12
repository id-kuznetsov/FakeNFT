//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 15.02.2025.
//

import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties
    
    weak var delegate: CartTableViewCellDelegate?
    
    // MARK: - Private Properties
    
    private var nftId: String?
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var ratingStackView: RatingStackView = {
        let ratingStackView = RatingStackView()
        return ratingStackView
    }()
    
    private lazy var descriptionPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = L10n.Cart.Label.price
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var removeFromCartButton: UIButton = {
        let button = UIButton()
        button.setImage(.icCartDelete, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapRemoveFromCartButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialisers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nftImageView.kf.cancelDownloadTask()
        nftImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapRemoveFromCartButton() {
        guard let nftId else { return }
        delegate?.didTapRemoveButton(with: nftId, image: nftImageView.image)
    }
    
    // MARK: - Public Methods
    
    func setupCell(with orderCard: OrderCard) {
        nftId = orderCard.id
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(with: orderCard.imageURL
        ){ [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                contentMode = .scaleAspectFill
                self.nftImageView.image = value.image
            case .failure(let error):
                assertionFailure("Failed set image in cell with error: \(error.localizedDescription)")
            }
        }
        ratingStackView.setRating(orderCard.rating)
        nameLabel.text = orderCard.name
        priceLabel.text = "\(orderCard.price) ETH"
    }
    
    // MARK: - Private Methods
    
    private func setupCellUI() {
        contentView.backgroundColor = .ypWhite
        contentView.addSubviews([nftImageView, nameLabel, descriptionPriceLabel, priceLabel, removeFromCartButton, ratingStackView])
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            imageConstraints() +
            nameLabelConstraints() +
            descriptionPriceLabelConstraints() +
            priceLabelConstraints() +
            removeFromCartButtonConstraints() +
            ratingImageViewConstraints()
        )
    }
    
    private func imageConstraints() -> [NSLayoutConstraint] {
        [
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108)
        ]
    }
    
    private func nameLabelConstraints() -> [NSLayoutConstraint] {
        [
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8)
        ]
    }
    
    private func ratingImageViewConstraints() -> [NSLayoutConstraint] {
        [
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68)
        ]
    }
    
    private func descriptionPriceLabelConstraints() -> [NSLayoutConstraint] {
        [
            descriptionPriceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionPriceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 28)
        ]
    }
    
    private func priceLabelConstraints() -> [NSLayoutConstraint] {
        [
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: descriptionPriceLabel.bottomAnchor, constant: 2)
        ]
    }
    
    private func removeFromCartButtonConstraints() -> [NSLayoutConstraint] {
        [
            removeFromCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeFromCartButton.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            removeFromCartButton.heightAnchor.constraint(equalToConstant: 40),
            removeFromCartButton.widthAnchor.constraint(equalToConstant: 40)
        ]
    }
}
