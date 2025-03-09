import UIKit

protocol FavouriteNftCellDelegate: AnyObject {
    func didTapFavouriteButton(on cell: FavouriteNftCell)
}

final class FavouriteNftCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties
    
    weak var delegate: FavouriteNftCellDelegate?
    var isLiked = true {
        didSet {
            nftCardView.isFavouriteButtonActive = isLiked
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var nftCardView: NFTCardView = {
        let nftCard = NFTCardView()
        nftCard.delegate = self
        nftCard.isFavouriteButtonActive = false
        nftCard.translatesAutoresizingMaskIntoConstraints = false
        return nftCard
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        return label
    }()
    
    private lazy var ratingStackView: RatingStackView = {
        let ratingStackView = RatingStackView(rating: 3)
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        return ratingStackView
    }()
    
    private lazy var headingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4.0
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        return label
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headingStackView, priceLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8.0
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCell(nft: Nft) {
        nftCardView.setImage(url: nft.previewImage)
        titleLabel.text = nft.name
        ratingStackView.setRating(nft.rating)
        priceLabel.text = "\(nft.price) ETH"
    }
    
    // MARK: - Private Methods
    
    private func setupContentView() {
        backgroundColor = .clear
        contentView.addSubviews(nftCardView, descriptionStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            nftCardView.heightAnchor.constraint(equalToConstant: 80),
            nftCardView.widthAnchor.constraint(equalToConstant: 80),
            nftCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            descriptionStackView.leadingAnchor.constraint(equalTo: nftCardView.trailingAnchor, constant: 12),
            descriptionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
        ])
    }
}

// MARK: - NFTCardDelegate

extension FavouriteNftCell: NFTCardDelegate {
    func didTapFavouriteButton(on view: NFTCardView) {
        delegate?.didTapFavouriteButton(on: self)
    }
}
