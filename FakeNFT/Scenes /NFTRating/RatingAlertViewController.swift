//
//  NFTRatingAlertViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 26.02.2025.
//

import UIKit

final class NFTRatingAlertViewController: UIViewController {
    // MARK: - Properties
    private var selectedRating: Int = 0
    private var buttons = [UIButton]()

    // MARK: - UI
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = view.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    private lazy var alertVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 17
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var infoVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .headline5
        view.textColor = .ypBlack
        view.textAlignment = .center
        view.text = L10n.Alert.Title.rateNft
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.font = .caption1
        view.textColor = .ypBlack
        view.textAlignment = .center
        view.text  = L10n.Alert.Message.rateNft
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var buttonsVStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var ratingButtonsContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var ratingButtonsHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var actionButtonsHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var notNowButton: UIButton = {
        let view = UIButton(type: .system)
        view.tag = 0
        view.setTitle(L10n.Alert.Button.notNow, for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.titleLabel?.font = .bodyRegular
        view.addTarget(self, action: #selector(didTapNotNow), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var rateButton: UIButton = {
        let view = UIButton(type: .system)
        view.tag = 1
        view.isHidden = true
        view.alpha = 0
        view.setTitle(L10n.Alert.Button.rate, for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.titleLabel?.font = .headline5
        view.addTarget(self, action: #selector(didTapRate), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let leftBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)

        self.imageView.image = image
        self.buttons = [notNowButton, rateButton]

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBackgroundUniversal

        view.addSubview(alertView)
        alertView.addSubview(blurView)
        alertView.addSubview(alertVStackView)
        alertVStackView.addArrangedSubview(imageView)
        alertVStackView.addArrangedSubview(infoVStackView)
        infoVStackView.addArrangedSubview(titleLabel)
        infoVStackView.addArrangedSubview(messageLabel)
        alertVStackView.addArrangedSubview(buttonsVStackView)
        buttonsVStackView.addArrangedSubview(ratingButtonsContainerView)
        ratingButtonsContainerView.addSubview(ratingButtonsHStackView)
        buttonsVStackView.addArrangedSubview(actionButtonsHStackView)

        setupConstraints()
        setupRatingButtons()
        addActionButtons()
    }

    private func setupRatingButtons() {
        for value in 0..<5 {
            let starButton = UIButton()
            starButton.tag = value + 1
            starButton.setImage(.star, for: .normal)
            starButton.tintColor = .systemBlue
            starButton.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            ratingButtonsHStackView.addArrangedSubview(starButton)

            NSLayoutConstraint.activate([
                starButton.heightAnchor.constraint(equalTo: ratingButtonsHStackView.heightAnchor)
            ])
        }
    }

    private func updateStars() {
        for case let button as UIButton in ratingButtonsHStackView.arrangedSubviews {
            let imageName = button.tag <= selectedRating ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    private func addActionButtons() {
        var tag = 0
        for button in buttons  {
            if button.tag > 0 {
                addLeftBorder(for: button)
            }
            tag += 1
            actionButtonsHStackView.addArrangedSubview(button)
        }
    }

    private func showRateButton() {
        guard rateButton.isHidden else { return }

        rateButton.isHidden = false
        rateButton.transform = CGAffineTransform(translationX: rateButton.frame.width, y: 0)

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.rateButton.alpha = 1
        })
    }

    // MARK: - Actions
    @objc
    private func starTapped(_ sender: UIButton) {
        selectedRating = sender.tag
        updateStars()
        showRateButton()
    }

    @objc
    private func didTapRate() {
        print("Rate button tapped - \(selectedRating)")
        dismiss(animated: true)
    }

    @objc
    private func didTapNotNow() {
        print("Not now button tapped")
        dismiss(animated: true)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 269),
            alertView.heightAnchor.constraint(equalToConstant: 287),

            alertVStackView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            alertVStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            alertVStackView.widthAnchor.constraint(equalTo: alertView.widthAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            infoVStackView.widthAnchor.constraint(equalToConstant: 241),

            ratingButtonsContainerView.heightAnchor.constraint(equalToConstant: 44),
            ratingButtonsContainerView.widthAnchor.constraint(equalTo: alertVStackView.widthAnchor),

            ratingButtonsHStackView.topAnchor.constraint(equalTo: ratingButtonsContainerView.topAnchor),
            ratingButtonsHStackView.bottomAnchor.constraint(equalTo: ratingButtonsContainerView.bottomAnchor),
            ratingButtonsHStackView.widthAnchor.constraint(equalToConstant: 200),
            ratingButtonsHStackView.centerXAnchor.constraint(equalTo: ratingButtonsContainerView.centerXAnchor),

            actionButtonsHStackView.heightAnchor.constraint(equalToConstant: 44),
            actionButtonsHStackView.widthAnchor.constraint(equalTo: alertVStackView.widthAnchor)
        ])
    }

    private func addLeftBorder(for button: UIButton) {
        button.addSubview(leftBorderView)

        NSLayoutConstraint.activate([
            leftBorderView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            leftBorderView.topAnchor.constraint(equalTo: button.topAnchor),
            leftBorderView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            leftBorderView.widthAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
