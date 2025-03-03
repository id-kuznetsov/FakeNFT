import UIKit

protocol EditingTextViewDelegate: AnyObject {
    func editingTextView(_ view: EditingTextView, didChangeText text: String?)
    func editingTextView(_ view: EditingTextView, shouldChangeText text: String) -> Bool
}

final class EditingTextView: UIView {
    
    // MARK: - Public Properties
    
    weak var delegate: EditingTextViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = .bodyRegular
        textView.backgroundColor = .ypLightGrey
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .ypPlaceholder
        label.textAlignment = .left
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setText(_ text: String) {
        placeholderLabel.isHidden = !text.isEmpty
        textView.text = text
    }
    
    func setPlaceholder(_ placeholder: String) {
        placeholderLabel.text = placeholder
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(textView)
        addSubview(placeholderLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 18),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -18),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
        ])
    }
}

// MARK: - UITextViewDelegate

extension EditingTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        return delegate?.editingTextView(self, shouldChangeText: newText) ?? false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        updateHeight()
        delegate?.editingTextView(self, didChangeText: textView.text)
    }
    
    private func updateHeight() {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = size.height
            }
        }
    }
}

