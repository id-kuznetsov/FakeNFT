import UIKit

final class RatingButton: UIButton {
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        titleLabel?.font = .caption2
    }

    func configure(rating: Int) {
        self.rating = min(max(rating, 0), maxStars)
    }

    private func updateTitle() {
        let stars = String(repeating: "★", count: maxStars)
        let attributedString = NSMutableAttributedString(string: stars)
        for i in 0..<maxStars {
            let starColor = i < rating ? UIColor.ypYellowUniversal : UIColor.ypLightGrey
            attributedString.addAttribute(.foregroundColor, value: starColor, range: NSRange(location: i, length: 1))
        }
        setAttributedTitle(attributedString, for: .normal)
    }
}
