import UIKit

final class ProfileEditingViewController: UIViewController {
    
    // MARK: - Section
    
    private enum Section: String, Hashable {
        case header
        case name
        case description
        case website
    }
    
    // MARK: - Item
    
    private enum Item: Hashable {
        case avatar(URL?, String)
        case textField(String)
        case textView(String)
        
        var cellHeight: CGFloat {
            switch self {
            case .avatar(_, _):
                return 70.0
            case .textField(_):
                return 44.0
            case .textView(_):
                return 44.0
            }
        }
    }
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: - Private Properties
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        button.setImage(.icClose, for: .normal)
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(AvatarCell.self)
        
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 80, left: 16, bottom: 40, right: -16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var dataSource: DataSource = {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .avatar(let url, let actionTitle):
                let cell = tableView.dequeueReusableCell(withIdentifier: AvatarCell.defaultReuseIdentifier)
                guard let avatarCell = cell as? AvatarCell else {
                    return cell
                }
                avatarCell.delegate = self
                avatarCell.setupCell(url: url, actionTitle: actionTitle)
                return avatarCell
                
            case .textField(_):
                return UITableViewCell()
            case .textView(_):
                return UITableViewCell()
            }
        }
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        applySnapshot()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubview(tableView)
        view.addSubview(dismissButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.heightAnchor.constraint(equalToConstant: 44),
            dismissButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.header])
        snapshot.appendItems([.avatar(nil, L10n.ProfileEditing.uploadPhoto)], toSection: .header)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Actions
    
    @objc private func dismissButtonDidTap() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ProfileEditingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return 0.0
        }
        return item.cellHeight
    }
}

// MARK: - AvatarCellDelegate

extension ProfileEditingViewController: AvatarCellDelegate {
    func didTapButton(on cell: AvatarCell) {
        
    }
}
