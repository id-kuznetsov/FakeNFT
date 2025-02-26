//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import UIKit

class NftCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - UI
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = LayoutConstants.Common.cornerRadiusMedium
        view.tintColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var favoriteButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(.heart, for: .normal)
        view.tintColor = .ypWhiteUniversal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = LayoutConstants.CollectionScreen.Cell.marginSmall
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var ratingButton: RatingButton = {
        let view = RatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .bodyBold
        view.textColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.font = .bodyMedium
        view.textColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var cartButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(.icCart, for: .normal)
        view.tintColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(nftImageView)
        nftImageView.addSubview(favoriteButton)

        addSubview(ratingButton)

        addSubview(nftHStackView)
        nftHStackView.addArrangedSubview(nftVStackView)
        nftVStackView.addArrangedSubview(nameLabel)
        nftVStackView.addArrangedSubview(priceLabel)
        nftHStackView.addArrangedSubview(cartButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Config
    func configure(nftUI: NftUI, imageLoaderService: ImageLoaderService) {
        ratingButton.configure(rating: nftUI.rating)
        nameLabel.text = nftUI.name
        priceLabel.text = nftUI.formattedPrice

        loadNftImage(
            from: nftUI.images.first,
            imageLoaderService: imageLoaderService
        )
    }

    // MARK: - Load Image
    private func loadNftImage(from url: URL?, imageLoaderService: ImageLoaderService) {
        showLoadingAnimation()

        imageLoaderService.loadImage(
            into: nftImageView,
            from: url
        )
        { [weak self] result in
            guard let self else { return }

            self.hideLoadingAnimation()

            switch result {
            case .success(let image):
                self.nftImageView.image = image
            case .failure(let error):
                print("DEBUG: Failed to load image: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Loading Animation
    private func showLoadingAnimation() {
        nftImageView.showShimmerAnimation()
    }

    private func hideLoadingAnimation() {
        nftImageView.hideShimmerAnimation()
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.heightAnchor.constraint(
                equalToConstant: LayoutConstants.CollectionScreen.Cell.imageHeight
            ),

            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            favoriteButton.heightAnchor.constraint(
                equalToConstant: LayoutConstants.CollectionScreen.Cell.buttonHeight
            ),
            favoriteButton.widthAnchor.constraint(
                equalToConstant: LayoutConstants.CollectionScreen.Cell.buttonWidth
            ),

            ratingButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingButton.topAnchor.constraint(
                equalTo: nftImageView.bottomAnchor,
                constant: LayoutConstants.CollectionScreen.Cell.marginRegular
            ),
            ratingButton.heightAnchor.constraint(
                equalToConstant: LayoutConstants.CollectionScreen.Cell.marginMedium
            ),

            nftHStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftHStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nftHStackView.topAnchor.constraint(
                equalTo: ratingButton.bottomAnchor,
                constant: LayoutConstants.CollectionScreen.Cell.marginSmall
            ),
            nftHStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -LayoutConstants.CollectionScreen.Cell.marginLarge),

            cartButton.heightAnchor.constraint(
                equalToConstant: LayoutConstants.CollectionScreen.Cell.buttonHeight
            ),
            cartButton.widthAnchor.constraint(
                equalToConstant: LayoutConstants.CollectionScreen.Cell.buttonWidth
            )
        ])
    }
}
