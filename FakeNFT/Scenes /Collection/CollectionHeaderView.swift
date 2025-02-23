//
//  CollectionHeaderView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView, ReuseIdentifying {
    // MARK: - UI
    private lazy var headerVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = LayoutConstants.Common.Margin.medium
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = LayoutConstants.Common.cornerRadiusMedium
        view.tintColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var aboutVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = LayoutConstants.Common.Margin.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .headline3
        view.textColor = .ypBlack
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var authorHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var authorLabel: UILabel = {
        let view = UILabel()
        view.font = .caption2
        view.textColor = .ypBlack
        view.textAlignment = .left
        view.text = L10n.Collection.author
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var authorButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.ypBlueUniversal, for: .normal)
        view.titleLabel?.font = .caption1
        view.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .caption2
        view.textColor = .ypBlack
        view.textAlignment = .left
        view.numberOfLines = 4
        view.lineBreakMode = .byWordWrapping
        view.contentMode = .topLeft
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(headerVStackView)

        headerVStackView.addArrangedSubview(coverImageView)
        headerVStackView.addArrangedSubview(aboutVStackView)

        aboutVStackView.addArrangedSubview(titleVStackView)
        titleVStackView.addArrangedSubview(nameLabel)
        titleVStackView.addArrangedSubview(authorHStackView)
        authorHStackView.addArrangedSubview(authorLabel)
        authorHStackView.addArrangedSubview(authorButton)
        aboutVStackView.addArrangedSubview(descriptionLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure(
        with model: CollectionUI,
        imageLoaderService: ImageLoaderService,
        coverImage: UIImage?
    ) {
        if let coverImage {
            coverImageView.image = coverImage
        } else {
            loadCoverImage(
                from: model.cover,
                imageLoaderService: imageLoaderService
            )
        }

        nameLabel.text = model.name
        authorButton.setTitle(model.author, for: .normal)
        descriptionLabel.text = model.description
    }

    // MARK: - Load Image
    private func loadCoverImage(from url: URL?, imageLoaderService: ImageLoaderService) {
        coverImageView.showShimmerAnimation()
        imageLoaderService.loadImage(
            into: coverImageView,
            from: url,
            placeholder: .scribble
        ) { [weak self] result in
            guard let self else { return }

            self.coverImageView.hideShimmerAnimation()
            switch result {
            case .success(let image):
                self.coverImageView.image = image
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Actions
    @objc
    private func didTapAuthorButton() {
        print("Author button tapped")
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerVStackView.topAnchor.constraint(equalTo: topAnchor),
            headerVStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerVStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerVStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            coverImageView.widthAnchor.constraint(equalTo: headerVStackView.widthAnchor),
        ])

        coverImageView.setHeightConstraintFromPx(
            heightPx: LayoutConstants.CollectionScreen.Header.coverImageHeight
        )
        aboutVStackView.setWidthConstraintFromPx(
            widthPx: LayoutConstants.CollectionScreen.Header.aboutVStackWidth
        )
    }
}
