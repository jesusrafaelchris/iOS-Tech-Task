import UIKit

class PercentageView: UIView {
    
    // MARK: - Properties
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor(red: 0.96, green: 1.00, blue: 0.99, alpha: 1.00)
        stackView.layer.cornerRadius = 16
        stackView.clipsToBounds = true
        stackView.layoutMargins = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.04, green: 0.52, blue: 0.32, alpha: 1.00)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        return imageView
    }()

    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.04, green: 0.52, blue: 0.32, alpha: 1.00)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(containerView)
        
        containerView.addArrangedSubview(arrowImage)
        containerView.addArrangedSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            arrowImage.widthAnchor.constraint(equalToConstant: 16),
            arrowImage.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(percentage: String) {
        percentageLabel.text = "\(percentage)"
        arrowImage.image = UIImage(systemName: "arrow.up.right")
    }
}
