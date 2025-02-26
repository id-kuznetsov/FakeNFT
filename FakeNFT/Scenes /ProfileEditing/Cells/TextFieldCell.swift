import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func textFieldCell(_ cell: TextFieldCell, didChangeText text: String?)
}

final class TextFieldCell: UITableViewCell, ReuseIdentifying {
    weak var delegate: TextFieldCellDelegate?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.backgroundColor = .ypLightGrey
        textField.font = .bodyRegular
        textField.textColor = .ypBlack
        textField.layer.cornerRadius = 12
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        textField.text = text
        textField.placeholder = placeholder
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(textField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    @objc private func textFieldDidChange() {
        delegate?.textFieldCell(self, didChangeText: textField.text)
    }
}
