import UIKit

final class ProfileEditingViewController: UIViewController, ErrorView {
    
    // MARK: Constants
    
    private let nameTextFieldIdentifier = "name-textfield"
    private let websiteTextFieldIdentifier = "website-textfield"
    
    // MARK: - Private Properties
    
    private let viewModel: ProfileEditingViewModel
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        button.setImage(.icClose, for: .normal)
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarView: AvatarView = {
        let view = AvatarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel = createHeaderLabel(text: L10n.ProfileEditing.name)
    
    private lazy var nameTextField = createTextField(
        placeholder: L10n.ProfileEditing.namePlaceholder,
        identifier: nameTextFieldIdentifier
    )
    
    private lazy var nameWarningLabel = UILabel()
    
    private lazy var descriptionLabel = createHeaderLabel(text: L10n.ProfileEditing.description)
    
    private lazy var descriptionTextView: EditingTextView = {
        let textView = EditingTextView()
        textView.delegate = self
        textView.setPlaceholder(L10n.ProfileEditing.descriptionPlaceholder)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var descriptionWarningLabel = UILabel()
    
    private lazy var websiteLabel = createHeaderLabel(text: L10n.ProfileEditing.website)
    
    private lazy var websiteTextField = createTextField(
        placeholder: L10n.ProfileEditing.websitePlaceholder,
        identifier: websiteTextFieldIdentifier
    )
    
    private lazy var websiteWarningLabel = UILabel()
    
    // MARK: - Init
    
    init(viewModel: ProfileEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupDataBindings()
        addDismissKeyboardGesture()
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(websiteLabel)
        contentView.addSubview(websiteTextField)
        view.addSubview(dismissButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            dismissButton.heightAnchor.constraint(equalToConstant: 42),
            dismissButton.widthAnchor.constraint(equalToConstant: 42),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            websiteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            websiteTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    private func setupDataBindings() {
        viewModel.avatar.bind { [weak self] avatar in
            self?.avatarView.avatar = avatar
        }
        
        viewModel.name.bind { [weak self] name in
            self?.nameTextField.text = name
        }
        
        viewModel.description.bind { [weak self] description in
            self?.descriptionTextView.setText(description)
        }
        
        viewModel.website.bind { [weak self] website in
            self?.websiteTextField.text = website
        }
        
        viewModel.errorModel.bind { [weak self] errorModel in
            if let errorModel {
                self?.showError(errorModel)
            }
        }
    }
    
    private func addDismissKeyboardGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func createHeaderLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .headline3
        label.textColor = .ypBlack
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createTextField(placeholder: String, identifier: String) -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.accessibilityIdentifier = identifier
        textField.placeholder = placeholder
        textField.backgroundColor = .ypLightGrey
        textField.font = .bodyRegular
        textField.textColor = .ypBlack
        textField.layer.cornerRadius = 12
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func findFirstResponder() -> UIView? {
        for view in contentView.subviews {
            if view.isFirstResponder {
                return view
            }
        }
        return nil
    }
    
    // MARK: - Actions
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func dismissButtonDidTap() {
        dismiss(animated: true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        if let activeTextField = findFirstResponder() as? UITextField {
            let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(textFieldFrame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - AvatarCellDelegate

extension ProfileEditingViewController: AvatarViewDelegate {
    func didTapButton(on view: AvatarView) {
        let alertController = UIAlertController(title: "Изменить изобаражение", message: nil, preferredStyle: .alert)
        alertController.addTextField { [weak self] textField in
            textField.placeholder = "Введите URL изображения"
            textField.text = self?.avatarView.avatar
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let textField = alertController.textFields?.first,
               let avatar = textField.text {
                self?.viewModel.avatarUpdateAction(updatedAvatar: avatar)
            }
        }
        alertController.addAction(okAction)
        
        let removeAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] action in
            self?.viewModel.avatarRemoveAction()
        }
        alertController.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didFailImageLoading() {
        viewModel.didFailImageLoading()
    }
}

// MARK: - UITextFieldDelegate

extension ProfileEditingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField.accessibilityIdentifier == nameTextFieldIdentifier {
            viewModel.nameDidChange(updatedName: newText)
        } else if textField.accessibilityIdentifier == websiteTextFieldIdentifier {
            viewModel.websiteDidChange(updatedWebsite: newText)
        }
        
        // Characters change using bindings
        return false
    }
}

// MARK: - EditingTextViewDelegate

extension ProfileEditingViewController: EditingTextViewDelegate {
    func editingTextView(_ view: EditingTextView, didChangeText text: String?) {
        self.view.layoutIfNeeded()
    }
    
    func editingTextView(_ view: EditingTextView, shouldChangeText text: String) -> Bool {
        viewModel.descriptionDidChange(updatedDescription: text)
        
        // Characters change using bindings
        return false
    }
}
