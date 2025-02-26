import UIKit

class ProfileEditingHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "ProfileEditingHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .ypBlack
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    // MARK: - Private Methods

    private func setupContentView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

