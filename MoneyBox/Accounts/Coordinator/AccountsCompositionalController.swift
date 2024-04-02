import UIKit

protocol AccountsCompositionalControllerProtocol {
    var dataSource: UICollectionViewDiffableDataSource<Int, InvestmentViewData>! { get set }
    func configureDataSource(collectionView: UICollectionView)
    func applySnapshot(items: [InvestmentViewData])
}

class AccountsCompositionalController: AccountsCompositionalControllerProtocol {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, InvestmentViewData>!
    
    func applySnapshot(items: [InvestmentViewData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, InvestmentViewData>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureDataSource(collectionView: UICollectionView) {
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
