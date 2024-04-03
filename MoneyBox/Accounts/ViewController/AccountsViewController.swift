import UIKit
import Networking

final class AccountsViewController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: AccountsViewModelProtocol
    private var accountsCompositionalController: AccountsCompositionalControllerProtocol
    
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
        setupView()
        accountsCompositionalController.configureDataSource(collectionView: collectionView)
        viewModel.fetchProducts()
        
        viewModel.didFetchAccounts = { [weak self] in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        guard let headerViewData = viewModel.accountsViewData.headerViewData else { return }
        header.configure(viewData: headerViewData)
        
        accountsCompositionalController.applySnapshot(
            items: viewModel.accountsViewData.investmentViewData ?? []
        )
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
