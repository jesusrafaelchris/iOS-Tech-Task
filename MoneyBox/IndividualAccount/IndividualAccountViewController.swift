import UIKit

final class IndividualAccountViewController: UIViewController {
    
    private var viewModel: IndividualAccountViewModelProtocol
    
    private lazy var colourBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: viewModel.account.productHexCode ?? "000000")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isAccessibilityElement = false
        return view
    }()
    
    private lazy var totalValueTitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.text = "TOTAL BALANCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        label.accessibilityLabel = "TOTAL BALANCE"
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.attributedText = viewModel.account.planValue?.formattedBalance(biggerFontSize: 40, smallerFontSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        label.accessibilityLabel = "\(viewModel.account.planValue ?? 0)"
        return label
    }()
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.00)
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Earning \(viewModel.account.earningsAsPercentage ?? 0.0)% APR"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        return label
    }()
    
    private lazy var addMoneyButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .small
        configuration.attributedTitle = AttributedString("Add Money", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(addMoney), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        button.accessibilityLabel = "Add Money"
        return button
    }()
    
    private lazy var withdrawMoneyButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = UIColor.accent
        configuration.buttonSize = .small
        configuration.attributedTitle = AttributedString("Withdraw", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        button.accessibilityLabel = "Withdraw Money"
        return button
    }()
    
    private lazy var upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(totalValueTitle)
        stackView.addArrangedSubview(totalValueLabel)
        stackView.addArrangedSubview(percentageLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.layer.shadowColor = UIColor.gray.cgColor
        stackView.layer.shadowOpacity = 0.25
        stackView.layer.shadowOffset = CGSize(width: 0, height: 0)
        stackView.layer.shadowRadius = 4
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = false
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.isAccessibilityElement = false
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.addArrangedSubview(addMoneyButton)
        stackView.addArrangedSubview(withdrawMoneyButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()
    
    private lazy var lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(buttonStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = false
        return stackView
    }()
    
    init(viewModel: IndividualAccountViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
        handleDidAddMoney()
        handleAddMoneyFailure()
    }
    
    private func handleDidAddMoney() {
        viewModel.didAddMoney = { [weak self] amount in
            self?.animateLabelChange()
        }
    }
    
    private func handleAddMoneyFailure() {
        viewModel.addMoneyFailure = { [weak self] error in
            self?.showErrorAlert(error: error)
        }
    }
    
    private func showErrorAlert(error: String?) {
        let alert = UIAlertController(title: "Oops!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addMoney() {
        viewModel.addMoney(amount: 10)
    }
    
    private func animateLabelChange() {
        let animation = CATransition()
        animation.duration = 0.2
        animation.type = .fade
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        totalValueLabel.layer.add(animation, forKey: "changeTextTransition")
        let newPlanValue = viewModel.increaseMoneyAmount(amount: 10)
        totalValueLabel.attributedText = newPlanValue.formattedBalance(biggerFontSize: 40, smallerFontSize: 20)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(colourBackground)
        view.addSubview(upperStackView)
        view.addSubview(lowerStackView)
        
        NSLayoutConstraint.activate([
            colourBackground.topAnchor.constraint(equalTo: view.topAnchor),
            colourBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colourBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colourBackground.heightAnchor.constraint(equalToConstant: 200),
            
            upperStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            upperStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            upperStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            lowerStackView.topAnchor.constraint(equalTo: upperStackView.bottomAnchor, constant: 16),
            lowerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lowerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addMoneyButton.heightAnchor.constraint(equalToConstant: 40),
            withdrawMoneyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupNavBar() {
        navigationItem.title = viewModel.account.friendlyName
        navigationItem.accessibilityLabel = viewModel.account.friendlyName
        navigationItem.accessibilityTraits = .header
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
