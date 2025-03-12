//
//  CollectionsTableViewCell.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 19.02.2025.
//

import UIKit

final class CollectionsTableViewCell: UITableViewCell, ReuseIdentifying {
    // MARK: - UI Components
    private lazy var cellVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = LayoutConstants.CollectionsScreen.cellSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var coverImageView: TopAlignedImageView = {
        let view = TopAlignedImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = LayoutConstants.Common.cornerRadiusMedium
        view.tintColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameAndCountLabel: UILabel = {
        let view = UILabel()
        view.font = .bodyBold
        view.textColor = .ypBlack
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .ypWhite

        contentView.addSubview(cellVStackView)
        cellVStackView.addArrangedSubview(coverImageView)
        cellVStackView.addArrangedSubview(nameAndCountLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            coverImageView.showShimmerAnimation()
        }
    }

    // MARK: - Config
    func configure(with model: Collection, imageLoaderService: ImageLoaderService) {
        if model.isPlaceholder {
            showLoadingAnimation()
            nameAndCountLabel.text = model.name
        } else {
            loadCoverImage(from: model.coverImageUrl, imageLoaderService: imageLoaderService)
            nameAndCountLabel.text = formatCollectionName(model.name, model.nfts.count)
        }
    }

    // MARK: - Load Image
    private func loadCoverImage(from url: URL?, imageLoaderService: ImageLoaderService) {
        showLoadingAnimation()

        imageLoaderService.loadImage(
            into: coverImageView,
            from: url
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.hideLoadingAnimation()
            }

            switch result {
            case .success(let image):
                self.coverImageView.adjustContentMode()
                self.coverImageView.image = image
            case .failure(let error):
                self.coverImageView.resetContentMode()
                print("DEBUG: Failed to load image: \(error.localizedDescription)")
            }
        }
    }

    private func formatCollectionName(_ name: String, _ count: Int) -> String {
        return "\(name) (\(count))"
    }

    // MARK: - Loading Animation
    private func showLoadingAnimation() {
        coverImageView.showShimmerAnimation()
    }

    private func hideLoadingAnimation() {
        coverImageView.hideShimmerAnimation()
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellVStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellVStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -LayoutConstants.CollectionsScreen.cellMargin
            ),

            cellVStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstants.Common.Margin.medium
            ),
            cellVStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LayoutConstants.Common.Margin.medium
            ),

            coverImageView.widthAnchor.constraint(equalTo: cellVStackView.widthAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 140),

            nameAndCountLabel.widthAnchor.constraint(equalTo: cellVStackView.widthAnchor, multiplier: 0.8)
        ])
    }
}
