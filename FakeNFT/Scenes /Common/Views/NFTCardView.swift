import UIKit
import Kingfisher

protocol NFTCardDelegate: AnyObject {
    func didTapFavouriteButton(on view: NFTCardView)
}

final class NFTCardView: UIView {

    // MARK: - Public Properties

    weak var delegate: NFTCardDelegate?

    var isFavouriteButtonActive: Bool = false {
        didSet {
            favouriteButton.setImage(
                isFavouriteButtonActive ? .icFavouriteActive : .icFavouriteInactive,
                for: .normal
            )
        }
    }

    // MARK: - Private Properties

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .ypLightGrey
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(favouriteButtonDidTap), for: .touchUpInside)
        button.setImage(.icFavouriteInactive, for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setImage(url: String) {
        guard let url = URL(string: url) else { return }
        let options: KingfisherOptionsInfo = [.transition(.fade(1)), .cacheOriginalImage ]
        nftImageView.kf.indicatorType = .activity

        nftImageView.kf.setImage(with: url, options: options) { [weak self] result in
            switch result {
            case .success:
                self?.favouriteButton.isHidden = false
            case .failure:
                self?.favouriteButton.isHidden = true
            }
        }
    }

    // MARK: - Private Methods

    private func setupView() {
        backgroundColor = .clear
        addSubviews([nftImageView, favouriteButton])
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            favouriteButton.heightAnchor.constraint(equalToConstant: 40),
            favouriteButton.widthAnchor.constraint(equalToConstant: 40),
            favouriteButton.topAnchor.constraint(equalTo: topAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func favouriteButtonDidTap() {
        delegate?.didTapFavouriteButton(on: self)
        isFavouriteButtonActive.toggle()
    }
}
