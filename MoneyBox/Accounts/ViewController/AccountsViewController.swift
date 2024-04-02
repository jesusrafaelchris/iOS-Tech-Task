import UIKit
import Networking

final class AccountsViewController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel: AccountsViewModelProtocol
    private var dataSource: UICollectionViewDiffableDataSource<Int, InvestmentViewData>!
    
    lazy var header: AccountsHeaderView = {
        let header = AccountsHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewModel.compositionalLayout
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
        collectionView.backgroundColor = .white
        return collectionView
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
        configureDataSource()
        viewModel.fetchProducts()
        
        viewModel.didFetchAccounts = { [weak self] in
            self?.updateUI()
        }
    }
    
    func updateUI() {
        guard let headerViewData = viewModel.accountsViewData.headerViewData else { return }
        header.configure(viewData: headerViewData)
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, InvestmentViewData>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.accountsViewData.investmentViewData ?? [])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupView() {
        view.addSubview(header)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<AccountCell, InvestmentViewData> { cell, indexPath, investment in
            cell.configure(viewData: investment)
        }
        
        let supplementaryViewRegistration = UICollectionView.SupplementaryRegistration<AccountSectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.configure(title: "Your Accounts")
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, InvestmentViewData>(collectionView: collectionView) {
            collectionView, indexPath, investment in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: investment)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryViewRegistration, for: indexPath)
        }
    }
}
