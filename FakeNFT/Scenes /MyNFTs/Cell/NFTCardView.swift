import UIKit

protocol NFTCardDelegate: AnyObject {
    func didTapFavouriteButton(on view: NFTCardView)
}

final class NFTCardView: UIView {
    weak var delegate: NFTCardDelegate?
    
    var isFavouriteButtonActive: Bool = false {
        didSet {
            favouriteButton.setImage(
                isFavouriteButtonActive ? .icFavouriteActive : .icFavouriteInactive,
                for: .normal
            )
        }
    }
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .ypBlack
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(favouriteButtonDidTap), for: .touchUpInside)
        button.setImage(.icFavouriteInactive, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage) {
        nftImageView.image = image
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubviews(nftImageView, favouriteButton)
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
            favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    @objc private func favouriteButtonDidTap() {
        delegate?.didTapFavouriteButton(on: self)
        isFavouriteButtonActive.toggle()
    }
}
