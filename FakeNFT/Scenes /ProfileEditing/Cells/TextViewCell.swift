import UIKit

protocol TextViewCellDelegate: AnyObject {
    func textViewCell(_ cell: TextViewCell, didChangeText text: String?)
}

final class TextViewCell: UITableViewCell, ReuseIdentifying {
    weak var delegate: TextViewCellDelegate?
    
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
        label.font = .bodyRegular
        label.textColor = .ypPlaceholderUniversal
        label.textAlignment = .left
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(text: String?, placeholder: String?) {
        textView.text = text
        placeholderLabel.text = placeholder
    }
    
    private func setupContentView() {
        contentView.addSubview(textView)
        contentView.addSubview(placeholderLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 18),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -18),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
        ])
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.textViewCell(self, didChangeText: textView.text)
    }
}

