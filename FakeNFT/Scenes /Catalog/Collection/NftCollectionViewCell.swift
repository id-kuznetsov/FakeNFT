//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import UIKit

protocol NftCollectionViewCellDelegate: AnyObject {
    func nftCollectionViewCellDidTapFavorite(_ nftId: String)
    func nftCollectionViewCellDidTapCart(_ nftId: String)
    func nftCollectionViewCellDidTapRating(_ nftImage: UIImage)
}

final class NftCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    weak var delegate: NftCollectionViewCellDelegate?
    private var nftId: String?

    // MARK: - UI
    private lazy var favoriteButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(.heart, for: .normal)
        view.tintColor = .ypWhiteUniversal
        view.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var cartButton: UIButton = {
        let view = UIButton(type: .custom)
        view.tintColor = .ypBlack
        view.addTarget(self, action: #selector(didTapCart), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = LayoutConstants.Common.cornerRadiusMedium
        view.tintColor = .systemGray
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
        view.addTarget(self, action: #selector(didTapRating), for: .touchUpInside)
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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(nftImageView)
        addSubview(favoriteButton)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        ratingButton.isHidden = false
        favoriteButton.isHidden = false
        cartButton.isHidden = false
        priceLabel.isHidden = false
        nftImageView.image = nil
    }

    // MARK: - Config
    func configure(model: CatalogNft, imageLoaderService: ImageLoaderService) {
        if model.isPlaceholder {
            showLoadingAnimation()
            ratingButton.isHidden = true
            favoriteButton.isHidden = true
            cartButton.isHidden = true
            priceLabel.isHidden = true
        } else {
            hideLoadingAnimation()
            ratingButton.isHidden = false
            favoriteButton.isHidden = false
            cartButton.isHidden = false
            priceLabel.isHidden = false

            ratingButton.configure(rating: model.rating)
            favoriteButton.tintColor = model.isLiked ? .ypRedUniversal : .ypWhiteUniversal
            cartButton.setImage(model.isInCart ? .icCartDelete : .icCart, for: .normal)
            nameLabel.text = model.name
            priceLabel.text = model.formattedPrice
        }

        nftId = model.id

        let preferredSize = model.isLiked
            ? UIImage.SymbolConfiguration(pointSize: 21, weight: .regular, scale: .default)
            : UIImage.SymbolConfiguration(pointSize: 17.64, weight: .regular, scale: .default)

        favoriteButton.setPreferredSymbolConfiguration(preferredSize, forImageIn: .normal)

        if let firstImageUrl = model.images.first {
            loadNftImage(
                from: firstImageUrl,
                imageLoaderService: imageLoaderService
            )
        }
    }

    // MARK: - Load Image
    private func loadNftImage(from url: URL?, imageLoaderService: ImageLoaderService) {
        showLoadingAnimation()

        imageLoaderService.loadImage(
            into: nftImageView,
            from: url
        ) { [weak self] result in
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

    // MARK: - Animations
    private func showLoadingAnimation() {
        nftImageView.showShimmerAnimation()
    }

    private func hideLoadingAnimation() {
        nftImageView.hideShimmerAnimation()
    }

    private func animateFavoriteButton() {
        let originalTransform = favoriteButton.transform

        UIView.animate(withDuration: 0.15, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, animations: {
                self.favoriteButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.favoriteButton.transform = originalTransform
                })
            })
        })
    }

    private func animateCartButton() {
        let newImage: UIImage = cartButton.image(for: .normal) == .icCart ? .icCartDelete : .icCart

        UIView.transition(
            with: cartButton,
            duration: 0.3,
            options: .transitionFlipFromLeft,
            animations: {
                self.cartButton.setImage(newImage, for: .normal)
            },
            completion: nil
        )
    }

    // MARK: - Actions
    @objc
    private func didTapFavorite() {
        guard let nftId = nftId else { return }

        animateFavoriteButton()
        delegate?.nftCollectionViewCellDidTapFavorite(nftId)
    }

    @objc
    private func didTapCart() {
        guard let nftId = nftId else { return }

        animateCartButton()
        delegate?.nftCollectionViewCellDidTapCart(nftId)
    }

    @objc
    private func didTapRating() {
        guard let image = nftImageView.image else { return }

        delegate?.nftCollectionViewCellDidTapRating(image)
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

            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor),
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
