import UIKit

protocol MyNFTCellDelegate: AnyObject {
    func didTapFavouriteButton(on cell: MyNFTCell)
}

final class MyNFTCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties
    
    weak var delegate: MyNFTCellDelegate?
    var isLiked = false {
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
    
    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption1
        label.text = L10n.MyNFTs.from
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption2
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        return label
    }()
    
    private lazy var authorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fromLabel, authorLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4.0
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingStackView, authorStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4.0
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .caption2
        label.text = L10n.MyNFTs.price
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .bodyBold
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, priceValueLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        authorLabel.text = nft.authorName
        priceValueLabel.text = "\(nft.price) ETH"
    }
    
    // MARK: - Private Methods
    
    private func setupContentView() {
        backgroundColor = .clear
        containerView.addSubviews(nftCardView, infoStackView, priceStackView)
        contentView.addSubview(containerView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -39),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            nftCardView.heightAnchor.constraint(equalToConstant: 108),
            nftCardView.widthAnchor.constraint(equalToConstant: 108),
            nftCardView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nftCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nftCardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 23),
            infoStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -23),
            infoStackView.leadingAnchor.constraint(equalTo: nftCardView.trailingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: priceStackView.leadingAnchor, constant: -39),
            
            priceStackView.widthAnchor.constraint(equalToConstant: 75),
            priceStackView.heightAnchor.constraint(equalToConstant: 42),
            priceStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            priceStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
        ])
    }
}

extension MyNFTCell: NFTCardDelegate {
    func didTapFavouriteButton(on view: NFTCardView) {
        delegate?.didTapFavouriteButton(on: self)
    }
}
