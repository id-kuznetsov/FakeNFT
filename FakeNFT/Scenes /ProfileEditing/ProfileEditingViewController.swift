import UIKit

final class ProfileEditingViewController: UIViewController {
    
    // MARK: - Section
    
    private enum Section: Hashable, CaseIterable {
        case header
        case name
        case description
        case website
        
        var title: String {
            switch self {
            case .header:
                return "none"
            case .name:
                return L10n.ProfileEditing.name
            case .description:
                return L10n.ProfileEditing.description
            case .website:
                return L10n.ProfileEditing.website
            }
        }
    }
    
    // MARK: - Item
    
    private enum Item: Hashable {
        case avatar(String)
        case textFieldName(String)
        case textView(String)
        case textFieldWebsite(String)
        
        var cellHeight: CGFloat {
            switch self {
            case .avatar(_):
                return 70.0
            case .textFieldName(_):
                return 44.0
            case .textView(_):
                return 44.0
            case .textFieldWebsite(_):
                return 44.0
            }
        }
    }
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: - Constants
    
    private let headerHeight: CGFloat = 60.0
    
    // MARK: - Private Properties
    
    private let viewModel: ProfileEditingViewModel
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        button.setImage(.icClose, for: .normal)
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.register(
            ProfileEditingHeaderView.self,
            forHeaderFooterViewReuseIdentifier: ProfileEditingHeaderView.reuseIdentifier
        )
        tableView.register(AvatarCell.self)
        tableView.register(TextFieldCell.self)
        tableView.register(TextViewCell.self)
        
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var dataSource: DataSource = {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .avatar(let avatar):
                let cell = tableView.dequeueReusableCell(withIdentifier: AvatarCell.defaultReuseIdentifier)
                guard let avatarCell = cell as? AvatarCell else {
                    return cell
                }
                avatarCell.delegate = self
                avatarCell.setupCell(avatar: avatar)
                return avatarCell
                
            case .textFieldName(let name):
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier)
                guard let textFieldCell = cell as? TextFieldCell else {
                    return cell
                }
                textFieldCell.delegate = self
                textFieldCell.setupCell(text: name, placeholder: L10n.ProfileEditing.namePlaceholder)
                return textFieldCell
                
            case .textView(let text):
                let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.defaultReuseIdentifier)
                guard let textViewCell = cell as? TextViewCell else { return cell }
                textViewCell.delegate = self
                textViewCell.setupCell(text: text, placeholder: L10n.ProfileEditing.descriptionPlaceholder)
                return textViewCell
                
            case .textFieldWebsite(let website):
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.defaultReuseIdentifier)
                guard let textFieldCell = cell as? TextFieldCell else {
                    return cell
                }
                textFieldCell.delegate = self
                textFieldCell.setupCell(text: website, placeholder: L10n.ProfileEditing.websitePlaceholder)
                return textFieldCell
            }
        }
    }()
    
    // MARK: - Init
    
    init(viewModel: ProfileEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupDataBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubview(tableView)
        view.addSubview(dismissButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.heightAnchor.constraint(equalToConstant: 44),
            dismissButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func setupDataBindings() {
        viewModel.profileEditingDto.bind { [weak self] dto in
            self?.applySnapshot(
                avatar: dto.avatar,
                name: dto.name,
                description: dto.description,
                website: dto.website
            )
        }
    }
    
    private func applySnapshot(avatar: String, name: String, description: String, website: String) {
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .name, .description, .website])
        snapshot.appendItems([.avatar(avatar)], toSection: .header)
        snapshot.appendItems([.textFieldName(name)], toSection: .name)
        snapshot.appendItems([.textView(description)], toSection: .description)
        snapshot.appendItems([.textFieldWebsite(website)], toSection: .website)
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
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return 0.0 }
        
        switch item {
        case .textView:
            return UITableView.automaticDimension
        default:
            return item.cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = Section.allCases[section]
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileEditingHeaderView.reuseIdentifier)
        guard let profileEditingHeaderView = headerView as? ProfileEditingHeaderView else {
            return nil
        }
        
        if section != .header {
            profileEditingHeaderView.setTitle(section.title)
        }
        return profileEditingHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return 0.0 }
        return item.cellHeight
    }
}

// MARK: - AvatarCellDelegate

extension ProfileEditingViewController: AvatarCellDelegate {
    func didTapButton(on cell: AvatarCell) {
        viewModel.avatarButtonDidTap()
    }
}

// MARK: - TextFieldCellDelegate

extension ProfileEditingViewController: TextFieldCellDelegate {
    func textFieldCell(_ cell: TextFieldCell, didChangeText text: String?) {
        guard let indexPath = tableView.indexPath(for: cell),
              let item = dataSource.itemIdentifier(for: indexPath) else {
            assertionFailure("Can't identify cell")
            return
        }
        
        switch item {
        case .textFieldName:
            viewModel.nameDidChange(updatedName: text ?? "")
        case .textFieldWebsite:
            viewModel.descriptionDidChange(updatedDescription: text ?? "")
        default:
            return
        }
    }
}

// MARK: - TextViewCellDelegate

extension ProfileEditingViewController: TextViewCellDelegate {
    func textViewCell(_ cell: TextViewCell, didChangeText text: String?) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        viewModel.descriptionDidChange(updatedDescription: text ?? "")
    }
}
