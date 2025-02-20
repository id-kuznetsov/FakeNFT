//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 19.02.2025.
//

import UIKit
import Kingfisher

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {

    // MARK: - UI Components
    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
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

    private lazy var shimmerImageView: ShimmerView = {
        let view = ShimmerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var shimmerLabelView: ShimmerView = {
        let view = ShimmerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(coverImageView)
        contentView.addSubview(shimmerImageView)
        contentView.addSubview(nameAndCountLabel)
        contentView.addSubview(shimmerLabelView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Config
    func configure(with model: CollectionUI) {
        loadCoverImage(url: model.cover)
        nameAndCountLabel.text = formatCollectionName(model.name, model.nfts.count)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        nameAndCountLabel.text = nil
        coverImageView.contentMode = .scaleAspectFill
        showLoadingAnimation()
    }

    // MARK: - KF
    private func loadCoverImage(url: URL?) {
        showLoadingAnimation()

        coverImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "scribble"),
            options: [.transition(.fade(0.3))]
        ) { [weak self] result in
            guard let self else { return }

            self.hideLoadingAnimation()

            if case .failure = result {
                self.coverImageView.contentMode = .scaleAspectFit
#if DEBUG
                print("DEBUG: Failed to load image")
#endif
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
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            shimmerImageView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            shimmerImageView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            shimmerImageView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            shimmerImageView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),

            nameAndCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameAndCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameAndCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            shimmerLabelView.leadingAnchor.constraint(equalTo: nameAndCountLabel.leadingAnchor),
            shimmerLabelView.widthAnchor.constraint(equalTo: nameAndCountLabel.widthAnchor, multiplier: 0.5),
            shimmerLabelView.topAnchor.constraint(equalTo: nameAndCountLabel.topAnchor),
            shimmerLabelView.bottomAnchor.constraint(equalTo: nameAndCountLabel.bottomAnchor)
        ])
    }
}
