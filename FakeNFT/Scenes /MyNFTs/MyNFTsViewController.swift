import UIKit

final class MyNFTsViewController: UIViewController {
    
    // MARK: - Section
    
    private enum Section: Hashable {
        case main
    }
    
    // MARK: - Item
    
    private struct MyNftModel: Hashable {
        
    }
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, MyNftModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyNftModel>
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNFTCell.self)
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var dataSource: DataSource = {
        DataSource(tableView: tableView) { tableView, indexPath, routeItem in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.defaultReuseIdentifier) else {
                return nil
            }
            return cell
        }
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupDataBindings()
        applySnapshot()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupDataBindings() {
        
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([MyNftModel()])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension MyNFTsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140.0
    }
}
