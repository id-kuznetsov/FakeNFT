//
//  CollectionHeaderView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView, ReuseIdentifying {
    // MARK: - Constants
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width

    private let headerVStackSpacing: CGFloat = 16
    private let coverImageHeight: CGFloat = 310
    private let aboutVStackSpacing: CGFloat = 8
    private let aboutVStackWidth: CGFloat = 341

    // MARK: - UI
    private lazy var headerVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .redraw
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.tintColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var aboutVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
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
        view.text = "Автор коллекции: "
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var authorButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.ypBlueUniversal, for: .normal)
        view.titleLabel?.font = .caption1
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

    private func calculateHeight(size: CGFloat) -> CGFloat {
        let multiplier = round((size / screenHeight) * 1000) / 1000
        let height = multiplier * screenHeight
        return round(height)
    }

    private func calculateWidth(size: CGFloat) -> CGFloat {
        let multiplier = round((size / screenWidth) * 1000) / 1000
        let width = multiplier * screenWidth
        return round(width)
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
        headerVStackView.spacing = calculateHeight(size: headerVStackSpacing)
        aboutVStackView.spacing = calculateHeight(size: aboutVStackSpacing)

        NSLayoutConstraint.activate([
            headerVStackView.topAnchor.constraint(equalTo: topAnchor),
            headerVStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerVStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerVStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            coverImageView.heightAnchor.constraint(equalToConstant: calculateHeight(size: coverImageHeight)),

            aboutVStackView.widthAnchor.constraint(equalToConstant: calculateWidth(size: aboutVStackWidth))
        ])
    }
}
