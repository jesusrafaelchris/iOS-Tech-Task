import UIKit

final class AccountsHeaderView: UIView {
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalValueTitle: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.text = "Total Value"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(greetingLabel)
        stackView.setCustomSpacing(24, after: greetingLabel)
        stackView.addArrangedSubview(totalValueTitle)
        stackView.setCustomSpacing(8, after: totalValueTitle)
        stackView.addArrangedSubview(totalValueLabel)
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
        ])
    }
    
    func configure(viewData: AccountHeaderViewData) {
        totalValueLabel.attributedText = viewData.formattedTotalValue
        greetingLabel.text = viewData.greeting
    }
}
