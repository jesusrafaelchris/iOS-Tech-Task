import UIKit

public protocol LoginTextFieldDelegate: AnyObject {
    func loginTextFieldDidReturn(_ textField: UITextField)
    func loginTextFieldDidBeginEditing(_ textField: UITextField)
}

final class LoginTextField: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LoginTextFieldDelegate?
    
    var text: String {
        return textField.text ?? ""
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondary
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.layer.borderColor = UIColor.border.cgColor
        textField.layer.borderWidth = 1
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 8
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isAccessibilityElement = true
        textField.accessibilityTraits = .searchField
        return textField
    }()
    
    private lazy var errorMessage: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        stackView.accessibilityElements = [titleLabel, textField]
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configure(title: String, isSecure: Bool = false, tag: Int) {
        titleLabel.text = title
        textField.isSecureTextEntry = isSecure
        textField.returnKeyType = isSecure ? .done : .next
        textField.tag = tag
        if isSecure {
            addShowPasswordButton()
        }
        
        setupA11y(title, isSecure)
    }
    
    func showError(error: String) {
        textField.layer.borderColor = UIColor.red.cgColor
        titleLabel.textColor = .red
        stackView.addArrangedSubview(errorMessage)
        errorMessage.text = error
        
        errorMessage.accessibilityLabel = error
    }
    
    func reset() {
        textField.layer.borderColor = UIColor.border.cgColor
        titleLabel.textColor = .secondary
        stackView.removeArrangedSubview(errorMessage)
        errorMessage.text = ""
        errorMessage.accessibilityLabel = ""
    }
    
    func setupA11y(_ title: String, _ isSecure: Bool) {
        stackView.accessibilityElements = [titleLabel, textField, errorMessage]
        textField.accessibilityLabel = isSecure ? "Password Field" : "Email Field"
        titleLabel.accessibilityLabel = title
    }
    
    func addShowPasswordButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "eye.fill")?.withTintColor(.accent ?? .black), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill")?.withTintColor(.accent ?? .black), for: .selected)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        textField.rightView = button
        textField.rightViewMode = .always
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        textField.isSecureTextEntry = !sender.isSelected
    }
}

// MARK: - UITextFieldDelegate

extension LoginTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.loginTextFieldDidReturn(textField)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.loginTextFieldDidBeginEditing(textField)
        return true
    }
}
