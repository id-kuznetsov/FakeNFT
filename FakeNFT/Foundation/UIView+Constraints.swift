import UIKit

extension UIView {

    func constraintEdges(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func constraintCenters(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setHeightConstraintFromPx(
        heightPx: CGFloat,
        baseWidth: CGFloat = LayoutConstants.Common.baseWidth
    ) {
        let scaleFactor = UIScreen.main.bounds.width / baseWidth
        let height = heightPx * scaleFactor

        self.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                self.removeConstraint(constraint)
            }
        }

        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setWidthConstraintFromPx(
        widthPx: CGFloat,
        baseWidth: CGFloat = LayoutConstants.Common.baseWidth
    ) {
        let scaleFactor = UIScreen.main.bounds.width / baseWidth
        let width = widthPx * scaleFactor

        self.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                self.removeConstraint(constraint)
            }
        }

        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
