import UIKit

protocol AccountsCompositionalControllerProtocol {
    var dataSource: UICollectionViewDiffableDataSource<Int, InvestmentViewData>! { get set }
    func configureDataSource(collectionView: UICollectionView)
    func applySnapshot(items: [InvestmentViewData])
    var compositionalLayout: UICollectionViewCompositionalLayout { get }
}

class AccountsCompositionalController: AccountsCompositionalControllerProtocol {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, InvestmentViewData>!
    
    var compositionalLayout: UICollectionViewCompositionalLayout = {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let headerSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1),
             heightDimension: .absolute(50)
         )
         let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: headerSize,
             elementKind: UICollectionView.elementKindSectionHeader,
             alignment: .top
         )
         
         let section = NSCollectionLayoutSection(group: group)
         section.boundarySupplementaryItems = [sectionHeader]
         
         return UICollectionViewCompositionalLayout(section: section)
    }()
    
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
