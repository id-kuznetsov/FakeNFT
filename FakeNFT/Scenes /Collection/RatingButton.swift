//
//  RatingButton.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 21.02.2025.
//

import UIKit

class RatingButton: UIButton {
    private let maxStars = 5
    private var rating: Int = 0 {
        didSet {
            updateTitle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setTitleColor(.systemYellow, for: .normal)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    func configure(rating: Int) {
        self.rating = min(max(rating, 0), maxStars) // Ограничение от 0 до 5
    }

    private func updateTitle() {
        let stars = (0..<maxStars).map { $0 < rating ? "★" : "☆" }.joined(separator: " ")
        setTitle(stars, for: .normal)
    }

    @objc private func didTap() {
        showRatingAlert()
    }

    private func showRatingAlert() {
        let alert = UIAlertController(title: "Оцените", message: nil, preferredStyle: .alert)
        let starsStackView = createStarsStackView(alert: alert)

        alert.view.addSubview(starsStackView)
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starsStackView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            starsStackView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50)
        ])

        let rateAction = UIAlertAction(title: "Оценить", style: .default) { _ in
            print("Выбран рейтинг: \(self.rating)")
        }
        let cancelAction = UIAlertAction(title: "Не сейчас", style: .cancel)

        alert.addAction(rateAction)
        alert.addAction(cancelAction)

        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(alert, animated: true)
        }
    }

    private func createStarsStackView(alert: UIAlertController) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        for i in 1...maxStars {
            let button = UIButton(type: .system)
            button.tag = i
            button.setTitle("★", for: .normal)
            button.setTitleColor(i <= rating ? .systemYellow : .lightGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        return stackView
    }

    @objc private func starTapped(_ sender: UIButton) {
        rating = sender.tag
        updateStars()
    }

    private func updateStars() {
        guard let alert = UIApplication.shared.windows.first?.rootViewController?.presentedViewController as? UIAlertController else { return }

        if let stackView = alert.view.subviews.compactMap({ $0 as? UIStackView }).first {
            for case let button as UIButton in stackView.arrangedSubviews {
                button.setTitleColor(button.tag <= rating ? .systemYellow : .lightGray, for: .normal)
            }
        }
    }
}

