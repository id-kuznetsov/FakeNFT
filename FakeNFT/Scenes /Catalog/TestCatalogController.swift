import UIKit

final class TestCatalogViewController: UIViewController {

    private lazy var ratingButton: RatingButton = {
        let view = RatingButton()

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let servicesAssembly: ServicesAssembly
    let testNftButton = UIButton()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(ratingButton)
        ratingButton.constraintCenters(to: view)
        ratingButton.setTitle(Constants.openNftTitle, for: .normal)
        ratingButton.addTarget(self, action: #selector(showNft), for: .touchUpInside)
        ratingButton.configure(rating: 3)
    }

    @objc
    func showNft() {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        let nftViewController = assembly.build(with: nftInput)
        present(nftViewController, animated: true)
    }
}

private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
}
