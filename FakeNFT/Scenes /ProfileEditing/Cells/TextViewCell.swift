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
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    }
    
    private func setupContentView() {
        contentView.addSubview(textView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewCell(self, didChangeText: textView.text)
    }
}

