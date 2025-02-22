//
//  PaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 19.02.2025.
//

import UIKit
import Kingfisher

final class PaymentCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Private Properties
    
    private lazy var paymentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.backgroundColor = .ypBlackUniversal
        return view
    }()
    
    private lazy var paymentShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGreenUniversal
        return label
    }()
    
    private lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configureCell(card: CurrencyCard) {
        paymentImageView.kf.indicatorType = .activity
        paymentImageView.kf.setImage(with: card.imageURL
        ){ [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                paymentImageView.contentMode = .scaleAspectFit
                self.paymentImageView.image = value.image
            case .failure(let error):
                print("Failed set image in cell with error: \(error.localizedDescription)")
            }
        }
        
        paymentLabel.text = card.name
        paymentShortNameLabel.text = card.shortName
    }
    
    func makeCellSelected(isSelected: Bool) {
        if isSelected {
            contentView.layer.cornerRadius = 12
            contentView.layer.masksToBounds = true
            contentView.layer.borderColor = UIColor.ypBlack.cgColor
            contentView.layer.borderWidth = 1
        } else {
            contentView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Private Methods
    
    private func setCellUI() {
        contentView.backgroundColor = .ypLightGrey
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubviews([imageBackgroundView, paymentImageView, paymentShortNameLabel, paymentLabel])
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate(
            imageConstraints() +
            paymentLabelConstraints() +
            shortNameConstraints() +
            imageBackgroundConstraints()
        )
    }
    
    private func imageConstraints() -> [NSLayoutConstraint] {
        [
            paymentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            paymentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            paymentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            paymentImageView.heightAnchor.constraint(equalToConstant: 36),
            paymentImageView.widthAnchor.constraint(equalToConstant: 36)
        ]
    }
    
    private func imageBackgroundConstraints() -> [NSLayoutConstraint] {
        [
            imageBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: 36)
        ]
    }
    
    private func shortNameConstraints() -> [NSLayoutConstraint] {
        [
            paymentShortNameLabel.leadingAnchor.constraint(equalTo: paymentImageView.trailingAnchor, constant: 4),
            paymentShortNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            paymentShortNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
    }
    
    private func paymentLabelConstraints() -> [NSLayoutConstraint] {
        [
            paymentLabel.leadingAnchor.constraint(equalTo: paymentImageView.trailingAnchor, constant: 4),
            paymentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            paymentLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
    }
}
