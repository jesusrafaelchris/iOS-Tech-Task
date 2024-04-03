import UIKit
import Networking

final class AccountsViewController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: AccountsViewModelProtocol
    private var accountsCompositionalController: AccountsCompositionalControllerProtocol
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    lazy var header: AccountsHeaderView = {
        let header = AccountsHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var promotionsBox: PromotionsBox = {
        let view = PromotionsBox()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: accountsCompositionalController.compositionalLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        collectionView.register(
            AccountSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AccountSectionHeaderView.reuseIdentifier
        )
        collectionView.layer.shadowColor = UIColor.gray.cgColor
        collectionView.layer.shadowOpacity = 0.25
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 0)
        collectionView.layer.shadowRadius = 4
        collectionView.layer.cornerRadius = 10
        collectionView.layer.masksToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.isAccessibilityElement = false
        collectionView.shouldGroupAccessibilityChildren = true
        return collectionView
    }()
    
    init(
        viewModel: AccountsViewModelProtocol,
        accountsCompositionalController: AccountsCompositionalControllerProtocol
    ) {
        self.viewModel = viewModel
        self.accountsCompositionalController = accountsCompositionalController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        accountsCompositionalController.configureDataSource(collectionView: collectionView)
        viewModel.fetchProducts()
        
        viewModel.fetchStateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateUI(for: state)
            }
        }
    }
    
    func updateUI(for state: FetchState) {
        switch state {
        case .loading:
            self.showSpinner(onView: view)
        case .success:
            configureData()
        case .failure(let errorMessage):
            showErrorAlert(message: errorMessage)
        }
    }

    func configureData() {
        removeSpinner()
        guard let headerViewData = viewModel.accountsViewData.headerViewData else { return }
        header.configure(viewData: headerViewData)
        
        accountsCompositionalController.applySnapshot(
            items: viewModel.accountsViewData.investmentViewData ?? []
        )
        setupView()
    }
    
    func showErrorAlert(message: String?) {
        removeSpinner()
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupView() {
        view.addSubview(header)
        view.addSubview(collectionView)
        view.addSubview(promotionsBox)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            promotionsBox.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 32),
            promotionsBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            promotionsBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            promotionsBox.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: promotionsBox.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
}

extension AccountsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = accountsCompositionalController.dataSource.itemIdentifier(for: indexPath) {
            navigateToIndivdualAccount(account: selectedItem)
        }
    }
    
    func navigateToIndivdualAccount(account: InvestmentViewData) {
        navigationItem.title = ""
        navigationController?.pushViewController(
            IndividualAccountViewController(
                viewModel: 
                    IndividualAccountViewModel(
                    dataProvider: viewModel.dataProvider,
                    account: account
                )
            ),
            animated: true
        )
    }
}
