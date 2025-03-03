import UIKit
import Kingfisher

protocol AvatarViewDelegate: AnyObject {
    func didTapButton(on view: AvatarView)
    func didFailImageLoading()
}

final class AvatarView: UIView {
    
    // MARK: - Public Properties
    
    weak var delegate: AvatarViewDelegate?
    
    var avatar: String = "" {
        didSet {
            guard let url = URL(string: avatar) else {
                avatarImageView.image = nil
                actionButton.setTitle(L10n.ProfileEditing.uploadPhoto, for: .normal)
                return
            }
            
            let options: KingfisherOptionsInfo = [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
            avatarImageView.kf.indicatorType = .activity
            avatarImageView.kf.setImage(with: url, options: options) { [weak self] result in
                switch result {
                case .success(_):
                    self?.actionButton.setTitle(L10n.ProfileEditing.changePhoto, for: .normal)
                case .failure(_):
                    self?.avatarImageView.image = nil
                    self?.delegate?.didFailImageLoading()
                }
            }
        }
    }
    
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
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackgroundUniversal
        view.layer.cornerRadius = avatarImageSize.height / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitleColor(.ypWhiteUniversal, for: .normal)
        button.titleLabel?.font = .caption3
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(avatarImageView)
        addSubview(overlayView)
        addSubview(actionButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarImageSize.height),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarImageSize.width),
            
            overlayView.centerXAnchor.constraint(equalTo: centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: centerYAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: avatarImageSize.height),
            overlayView.widthAnchor.constraint(equalToConstant: avatarImageSize.width),
            
            actionButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: 5),
            actionButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -5),
            actionButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func actionButtonDidTap() {
        delegate?.didTapButton(on: self)
    }
}
