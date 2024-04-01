import UIKit
import Networking

final class AccountsViewController: UIViewController {
    
    // MARK: Properties

    private var viewModel: AccountsViewModelProtocol
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkAccent
        label.text = viewModel.greeting
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var header: AccountsHeaderView = {
        let header = AccountsHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    
    init(viewModel: AccountsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        viewModel.fetchProducts()
        
        viewModel.didFetchAccounts = { [weak self] in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        header.configure(
            totalValue: viewModel.totalValue
        )
    }
    
    private func setupView() {
        view.addSubview(greetingLabel)
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            header.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 24),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
