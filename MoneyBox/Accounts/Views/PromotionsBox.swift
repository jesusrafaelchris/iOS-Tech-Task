import UIKit

class PromotionsBox: UIView {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let promotionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "moneyboxLighthouse")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Pension Calculator"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Get on track for\nlife after work"
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.right", withConfiguration: configuration), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.setCustomSpacing(8, after: subtitleLabel)
        stackView.addArrangedSubview(arrowButton)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(verticalStackView)
        addSubview(promotionImage)
        addSubview(containerView)
        containerView.addSubview(promotionImage)
        
        backgroundColor = .darkAccent
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.cornerRadius = 10
        layer.masksToBounds = false
        clipsToBounds = true
        isAccessibilityElement = false
        shouldGroupAccessibilityChildren = true
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            promotionImage.heightAnchor.constraint(equalToConstant: 140),
            promotionImage.widthAnchor.constraint(equalToConstant: 140),
            
            promotionImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            promotionImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            promotionImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 32),
            promotionImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
