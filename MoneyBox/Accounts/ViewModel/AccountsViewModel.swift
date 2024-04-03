import UIKit
import Networking
enum FetchState {
    case loading
    case success
    case failure(String?)
}

protocol AccountsViewModelProtocol: AnyObject {
    func fetchProducts()
    var fetchStateDidChange: ((FetchState) -> Void)? { get set }
    var accountsViewData: AccountViewData { get }
    var dataProvider: DataProviderProtocol { get }
    func greetingForTime() -> String
}

final class AccountsViewModel: AccountsViewModelProtocol {
    
    let dataProvider: DataProviderProtocol
    private let user: LoginResponse.User
    
    var fetchStateDidChange: ((FetchState) -> Void)?
    
    private var fetchState: FetchState = .loading {
        didSet {
            fetchStateDidChange?(fetchState)
        }
    }
    
    var accountsViewData = AccountViewData() {
        didSet {
            fetchState = .success
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
        DispatchQueue.main.async {
            self.fetchState = .loading
        }
        dataProvider.fetchProducts { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let model):
                strongSelf.updateAccountViewData(with: model)
            case .failure(let failure):
                strongSelf.fetchState = .failure(failure.message)
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
    
    func greetingForTime() -> String {
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
}
