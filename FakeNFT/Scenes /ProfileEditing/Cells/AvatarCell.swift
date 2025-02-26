import UIKit
import Kingfisher

protocol AvatarCellDelegate: AnyObject {
    func didTapButton(on cell: AvatarCell)
}

final class AvatarCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties
    
    weak var delegate: AvatarCellDelegate?
    
    // MARK: - Private Properties
    
    private let avatarImageSize = CGSize(width: 70, height: 70)
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .ypBlack
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = avatarImageSize.height / 2
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.titleLabel?.textColor = .ypWhite
        button.titleLabel?.font = .caption3
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCell(url: URL?, actionTitle: String) {
        if let url {
            let options: KingfisherOptionsInfo = [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
            avatarImageView.kf.indicatorType = .activity
            avatarImageView.kf.setImage(with: url, options: options)
        }
        actionButton.setTitle(actionTitle, for: .normal)
    }
    
    // MARK: - Private Methods
    
    private func setupContentView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(avatarImageView)
        contentView.addSubview(actionButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarImageSize.height),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarImageSize.width),
            
            actionButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: 10),
            actionButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -10),
            actionButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
        ])
    }
    
    @objc private func actionButtonDidTap() {
        delegate?.didTapButton(on: self)
    }
}
