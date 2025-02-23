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

    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
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
        view.clipsToBounds = true
        view.layer.cornerRadius = LayoutConstants.Common.cornerRadiusRegular
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // TODO: - Refactor Shimmer
    private lazy var shimmerImageView: ShimmerView = {
        let view = ShimmerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var shimmerLabelView: ShimmerView = {
        let view = ShimmerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .ypWhite

        contentView.addSubview(cellVStackView)
        cellVStackView.addArrangedSubview(coverImageView)
        coverImageView.addSubview(shimmerImageView)
        cellVStackView.addArrangedSubview(nameAndCountLabel)
        nameAndCountLabel.addSubview(shimmerLabelView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        nameAndCountLabel.text = nil
        coverImageView.contentMode = .scaleAspectFill
        showLoadingAnimation()
    }

    // MARK: - Config
    func configure(with model: CollectionUI, imageLoaderService: ImageLoaderService) {
        loadCoverImage(from: model.cover, imageLoaderService: imageLoaderService)
        nameAndCountLabel.text = formatCollectionName(model.name, model.nfts.count)
    }

    func getLoadedImage() -> UIImage? {
        return coverImageView.image
    }

    // MARK: - Load Image
    private func loadCoverImage(from url: URL?, imageLoaderService: ImageLoaderService) {
        showLoadingAnimation()
        imageLoaderService.loadImage(
            into: coverImageView,
            from: url,
            placeholder: .scribble
        ) { [weak self] result in
            guard let self else { return }

            self.hideLoadingAnimation()
            switch result {
            case .success(let image):
                self.coverImageView.image = image
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }

    private func formatCollectionName(_ name: String, _ count: Int) -> String {
        return "\(name) (\(count))"
    }

    // MARK: - Animation
    private func showLoadingAnimation() {
        self.shimmerImageView.isHidden = false
        self.shimmerLabelView.isHidden = false
    }

    private func hideLoadingAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }

            self.shimmerImageView.isHidden = true
            self.shimmerLabelView.isHidden = true
        }
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellVStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellVStackView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
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

            shimmerImageView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            shimmerImageView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            shimmerImageView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            shimmerImageView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),

            nameAndCountLabel.widthAnchor.constraint(equalTo: cellVStackView.widthAnchor, multiplier: 0.8),

            shimmerLabelView.leadingAnchor.constraint(equalTo: nameAndCountLabel.leadingAnchor),
            shimmerLabelView.widthAnchor.constraint(equalTo: nameAndCountLabel.widthAnchor),
            shimmerLabelView.topAnchor.constraint(equalTo: nameAndCountLabel.topAnchor),
            shimmerLabelView.bottomAnchor.constraint(equalTo: nameAndCountLabel.bottomAnchor)
        ])

        coverImageView.setHeightConstraintFromPx(
            heightPx: LayoutConstants.CollectionsScreen.coverImageHeight
        )
    }
}
