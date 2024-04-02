import UIKit
import Networking

protocol AccountsViewModelProtocol: AnyObject {
    func fetchProducts()
    var didFetchAccounts: (() -> Void)? { get set }
    var accountsViewData: AccountViewData { get }
    var compositionalLayout: UICollectionViewCompositionalLayout { get set }
}

final class AccountsViewModel: AccountsViewModelProtocol {
    
    private let dataProvider: DataProviderProtocol
    private let user: LoginResponse.User
    
    var didFetchAccounts: (() -> Void)?

    var accountsViewData = AccountViewData() {
        didSet {
            didFetchAccounts?()
        }
    }
    
    init(
        dataProvider: DataProviderProtocol,
        user: LoginResponse.User
    ) {
        self.dataProvider = dataProvider
        self.user = user
    }
    
    func fetchProducts() {
        dataProvider.fetchProducts { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let model):
                strongSelf.updateAccountViewData(with: model)
            case .failure(let failure):
                print(failure.message)
            }
        }
    }
    
    private func updateAccountViewData(with model: AccountResponse) {
        let headerViewData = model.asViewData(greeting: greeting)
        let investmentsViewData = model.productResponses?.map({ $0.asViewData })
        
        accountsViewData = AccountViewData(
            headerViewData: headerViewData,
            investmentViewData: investmentsViewData
        )
    }
    
    private var greeting: String {
        guard let name = user.firstName else { return ""}
        return "\(greetingForTime()), \(name)"
    }
    
    private func greetingForTime() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<18:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
    
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
}
