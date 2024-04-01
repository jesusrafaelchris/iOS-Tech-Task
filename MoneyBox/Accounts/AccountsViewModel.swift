import Foundation
import Networking

protocol AccountsViewModelPresenter {
    func updateContent()
}

protocol AccountsViewModelProtocol: AnyObject {
    func fetchProducts()
    var greeting: String { get }
    var totalValue: String { get }
    var didFetchAccounts: (() -> Void)? { get set }
    var accountsViewData: AccountViewData { get }
}

final class AccountsViewModel: AccountsViewModelProtocol {
    
    private let dataProvider: DataProviderProtocol
    private let sessionManager: SessionManagerProtocol
    private let user: LoginResponse.User
    
    var didFetchAccounts: (() -> Void)?

    var accountsViewData = AccountViewData() {
        didSet {
            didFetchAccounts?()
        }
    }
    
    init(dataProvider: DataProviderProtocol,
         sessionManager: SessionManagerProtocol,
         user: LoginResponse.User
    ) {
        self.dataProvider = dataProvider
        self.sessionManager = sessionManager
        self.user = user
    }
    
    func fetchProducts() {
        dataProvider.fetchProducts { result in
            switch result {
            case .success(let model):
                print(model)
                self.accountsViewData = .init(totalPlanValue: model.totalPlanValue, totalEarnings: model.totalEarnings)
            case .failure(let failure):
                print(failure.message)
            }
        }
    }
    
    var greeting: String {
        guard let name = user.firstName else { return ""}
        return "\(greetingForTime()) \(name)"
    }
    
    var totalValue: String {
        return "\(accountsViewData.formattedTotal)"
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
}
