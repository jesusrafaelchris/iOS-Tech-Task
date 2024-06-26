import UIKit

final class AccountsHeaderView: UIView {
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
        imageView.accessibilityLabel = "MoneyBox Logo Image"
        return imageView
    }()
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .header
        return label
    }()
    
    private lazy var dailyMessage: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var topVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(greetingLabel)
        stackView.setCustomSpacing(4, after: greetingLabel)
        stackView.addArrangedSubview(dailyMessage)
        stackView.setCustomSpacing(24, after: dailyMessage)
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()
    
    private lazy var topHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(logoImage)
        stackView.addArrangedSubview(topVerticalStackView)
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()
    
    private lazy var totalValueTitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var totalEarntLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.00)
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var totalEarntTitle: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var earntStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubview(totalEarntLabel)
        stackView.addArrangedSubview(totalEarntTitle)
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()
    
    private lazy var valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(totalValueLabel)
        stackView.addArrangedSubview(earntStackView)
        stackView.spacing = 80
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()

    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(topHorizontalStackView)
        stackView.setCustomSpacing(24, after: topHorizontalStackView)
        stackView.addArrangedSubview(totalValueTitle)
        stackView.setCustomSpacing(4, after: totalValueTitle)
        stackView.addArrangedSubview(valueStackView)
        stackView.setCustomSpacing(24, after: valueStackView)
        stackView.addArrangedSubview(actionStackView)
        stackView.setCustomSpacing(12, after: actionStackView)
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
            
            logoImage.heightAnchor.constraint(equalToConstant: 40),
            logoImage.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(viewData: AccountHeaderViewData) {
        totalValueTitle.text = "TOTAL BALANCE"
        logoImage.image = UIImage(named: "moneyBoxLogo")
        totalEarntLabel.attributedText = viewData.totalEarnings?.formattedBalance(biggerFontSize: 20, smallerFontSize: 16)
        totalEarntTitle.text = "Earned all time"
        totalValueLabel.attributedText = viewData.totalPlanValue?.formattedBalance(biggerFontSize: 40, smallerFontSize: 20)
        greetingLabel.text = viewData.greeting
        dailyMessage.text = "Little and often is the best way to save. \r\nAdd a little extra to your Moneybox."
        setupA11y(viewData: viewData)
        
        viewData.actions.forEach({
            let actionButton = ActionButton()
            actionButton.configure(amount: $0.amount, label: $0.label)
            actionButton.isAccessibilityElement = true
            actionButton.accessibilityTraits = .button
            actionButton.accessibilityLabel = $0.label
            actionStackView.addArrangedSubview(actionButton)
        })
    }
    
    private func setupA11y(viewData: AccountHeaderViewData) {
        totalValueTitle.accessibilityLabel = "TOTAL BALANCE"
        totalEarntLabel.accessibilityLabel = "\(viewData.totalEarnings ?? 0)"
        totalEarntTitle.accessibilityLabel = "Earned all time"
        totalValueLabel.accessibilityLabel = "\(viewData.totalPlanValue ?? 0)"
        greetingLabel.accessibilityLabel = viewData.greeting
        dailyMessage.accessibilityLabel = "Little and often is the best way to save. \r\nAdd a little extra to your Moneybox."
    }
}
