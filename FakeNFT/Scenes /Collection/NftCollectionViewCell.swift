//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import UIKit

class NftCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    private lazy var cellVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
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

    private lazy var nftVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nftHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
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
        view.font = .headline3
        view.textColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.font = .headline3
        view.textColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var cartButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(.icCart, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .ypYellowUniversal

        addSubview(cellVStackView)
        cellVStackView.addArrangedSubview(nftImageView)//addSubview(nftImageView)
        nftImageView.addSubview(favoriteButton)
        cellVStackView.addArrangedSubview(ratingButton)
        cellVStackView.addArrangedSubview(nftHStackView)
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

    func configure(nftUI: NftUI) {
        loadNftImage(url: nftUI.images.first)

        ratingButton.configure(rating: nftUI.rating)
        nameLabel.text = nftUI.name
        priceLabel.text = nftUI.formattedPrice
    }

    // MARK: - KF
    private func loadNftImage(url: URL?) {
//        showLoadingAnimation()

        nftImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "scribble"),
            options: [.transition(.fade(0.3))]
        ) { /*[weak self]*/ result in
//            guard let self else { return }

//            self.hideLoadingAnimation()

            if case .failure = result {
//                self.coverImageView.contentMode = .scaleAspectFit
#if DEBUG
                print("DEBUG: Failed to load image")
#endif
            }
        }
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellVStackView.topAnchor.constraint(equalTo: topAnchor),
            cellVStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellVStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellVStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            nftImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.56),

            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),


        ])

    }
}
