import Foundation
import Networking

protocol IndividualAccountViewModelProtocol {
    func addTenPounds()
    var account: InvestmentViewData { get set }
}

final class IndividualAccountViewModel: IndividualAccountViewModelProtocol {
    
    private let dataProvider: DataProviderProtocol
    var account: InvestmentViewData
    
    init(
        dataProvider: DataProviderProtocol,
        account: InvestmentViewData
    ) {
        self.dataProvider = dataProvider
        self.account = account
    }
    
    func addTenPounds() {
        guard let productID = account.productID else { return }
        let request = OneOffPaymentRequest(amount: 10, investorProductID: productID)
        dataProvider.addMoney(request: request) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
