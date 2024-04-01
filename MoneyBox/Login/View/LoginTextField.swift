import UIKit

protocol LoginTextFieldDelegate: AnyObject {
    func loginTextFieldDidReturn(_ textField: UITextField)
    func loginTextFieldDidChange(_ textField: UITextField)
}

final class LoginTextField: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LoginTextFieldDelegate?
    
    var text: String? {
        return textField.text
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondary
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        return textField
    }()
    
    private lazy var errorMessage: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    func showError(error: String) {
        textField.layer.borderColor = UIColor.red.cgColor
        titleLabel.textColor = .red
        stackView.addArrangedSubview(errorMessage)
        errorMessage.text = error
    }
    
    func reset() {
        textField.layer.borderColor = UIColor.border.cgColor
        titleLabel.textColor = .secondary
        stackView.removeArrangedSubview(errorMessage)
        errorMessage.text = ""
    }
}

// MARK: - UITextFieldDelegate

extension LoginTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.loginTextFieldDidReturn(textField)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.loginTextFieldDidChange(textField)
    }
}
