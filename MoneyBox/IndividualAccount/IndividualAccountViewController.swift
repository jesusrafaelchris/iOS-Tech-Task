import UIKit

final class IndividualAccountViewController: UIViewController {
    
    private let viewModel: IndividualAccountViewModelProtocol
    
    private lazy var colourBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hex: viewModel.account.productHexCode ?? "000000")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var totalValueTitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.text = "TOTAL BALANCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.attributedText = viewModel.account.planValue?.formattedBalance(biggerFontSize: 40, smallerFontSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.00)
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Earning \(viewModel.account.earningsAsPercentage ?? 0.0)% APR"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addMoneyButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .small
        configuration.image = UIImage(systemName: "plus.circle.fill")?.withTintColor(.white)
        configuration.title = "Add Money"
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var withdrawMoneyButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = UIColor.accent
        configuration.buttonSize = .small
        configuration.image = UIImage(systemName: "minus.circle.fill")?.withTintColor(.white)
        configuration.title = "Withdraw"
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(add10Pounds), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc
    func add10Pounds() {
        viewModel.addTenPounds()
    }
    
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
        return stackView
    }()
    
    private lazy var lowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(buttonStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        updateUI()
    }
    
    func updateUI() {
    }
    
    func setupView() {
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
    
    func setupNavBar() {
        navigationItem.title = viewModel.account.friendlyName
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
