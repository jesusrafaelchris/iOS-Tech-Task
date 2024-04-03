import UIKit

class ActionButton: UIView {
    
    // MARK: - Properties
    
    private lazy var amountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.backgroundColor = .accent
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkAccent
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [amountButton, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
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
            
            amountButton.heightAnchor.constraint(equalToConstant: 44),
            amountButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(amount: String?, label: String?) {
        amountButton.setTitle("£\(amount ?? "0")", for: .normal)
        amountButton.accessibilityLabel = label
        titleLabel.text = label
        titleLabel.accessibilityLabel = label
    }
}
