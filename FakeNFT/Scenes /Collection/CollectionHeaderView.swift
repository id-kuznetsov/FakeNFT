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
        view.contentMode = .redraw
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
        // TODO: Add action
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


    func configure(with model: CollectionUI, skipImageLoading: Bool = false) {
        nameLabel.text = model.name
        authorButton.setTitle(model.author, for: .normal)
        descriptionLabel.text = model.description

        if !skipImageLoading {
            loadCoverImage(url: model.cover)
        }
    }

    // MARK: - KF
    private func loadCoverImage(url: URL?) {

        coverImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "scribble"),
            options: [.transition(.fade(0.3))]
        ) { result in

            if case .failure = result {
                self.coverImageView.contentMode = .scaleAspectFit
#if DEBUG
                print("DEBUG: Failed to load image")
#endif
            }
        }
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerVStackView.topAnchor.constraint(equalTo: topAnchor),
            headerVStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerVStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerVStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        coverImageView.setHeightConstraintFromPx(
            heightPx: LayoutConstants.CollectionScreen.Header.coverImageHeight
        )
        aboutVStackView.setWidthConstraintFromPx(
            widthPx: LayoutConstants.CollectionScreen.Header.aboutVStackWidth
        )
    }
}
