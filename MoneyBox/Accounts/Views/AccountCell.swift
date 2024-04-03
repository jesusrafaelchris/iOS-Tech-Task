import UIKit

class AccountCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "AccountCell"
    let imageDownloader = ImageDownloader()
    
    private lazy var accountImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var value: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var percentage: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel//UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.00)
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        imageView.tintColor = .mediumAccent
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(percentage)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        contentView.addSubview(accountImage)
        contentView.addSubview(stackView)
        contentView.addSubview(value)
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            accountImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            accountImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            accountImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            accountImage.widthAnchor.constraint(equalToConstant: 40),
            
            stackView.leadingAnchor.constraint(equalTo: accountImage.trailingAnchor, constant: 8),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: value.leadingAnchor, constant: 16),
            
            value.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -2),
            value.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
    
    func configure(viewData: InvestmentViewData) {
        name.text = viewData.friendlyName
        value.attributedText = viewData.planValue?.formattedBalance(biggerFontSize: 20, smallerFontSize: 16)
        percentage.text = "\(viewData.earningsAsPercentage ?? 0.0)%"
        setupA11y(viewData: viewData)
        
        Task {
            do {
                let image = try await imageDownloader.downloadImage(from: viewData.pngImageUrl)
                accountImage.image = image
            } catch {
                accountImage.image = UIImage(systemName: "banknote.fill")
            }
        }
    }
    
    func setupA11y(viewData: InvestmentViewData) {
        isAccessibilityElement = true
        accessibilityLabel = "\(viewData.friendlyName!), \(viewData.planValue ?? 0), earning \(viewData.earningsAsPercentage ?? 0.0)"
        accessibilityHint = "Tap to view account"
        accountImage.isAccessibilityElement = false
        name.isAccessibilityElement = false
        value.isAccessibilityElement = false
        percentage.isAccessibilityElement = false
        chevronImageView.isAccessibilityElement = false
    }
}
