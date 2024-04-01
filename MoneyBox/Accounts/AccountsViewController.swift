import UIKit
import Networking

final class AccountsViewController: UIViewController {
    
    private var viewModel: AccountsViewModelProtocol
    
    // MARK: Properties

    private var accounts = AccountViewData() {
        didSet {
            //tableView.reloadData()
        }
    }
    
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
        print(viewModel.accountsViewData.lifetime)
        print(viewModel.accountsViewData.totalPlanValue)
        header.configure(greeting: "\(viewModel.accountsViewData.lifetime)", totalValue: viewModel.accountsViewData.totalPlanValue ?? 1.2)
    }
    
    private func setupView() {
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
