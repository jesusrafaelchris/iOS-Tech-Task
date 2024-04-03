import Foundation
import Networking

protocol IndividualAccountViewModelProtocol {
    func addMoney(amount: Int)
    var account: InvestmentViewData { get set }
    var didAddMoney: ((Double?) -> Void)? { get set }
    var addMoneyFailure: ((String?) -> Void)? { get set }
    func increaseMoneyAmount(amount: Int) -> Double
}

final class IndividualAccountViewModel: IndividualAccountViewModelProtocol {
    
    private let dataProvider: DataProviderProtocol
    var account: InvestmentViewData
    
    var didAddMoney: ((Double?) -> Void)?
    var addMoneyFailure: ((String?) -> Void)?
    
    init(
        dataProvider: DataProviderProtocol = DataProvider(),
        account: InvestmentViewData
    ) {
        self.dataProvider = dataProvider
        self.account = account
    }
    
    func addMoney(amount: Int) {
        guard let productID = account.productID else { return }
        let request = OneOffPaymentRequest(amount: amount, investorProductID: productID)
        dataProvider.addMoney(request: request) { [weak self] result in
            switch result {
            case .success(let success):
                self?.didAddMoney?(success.moneybox)
            case .failure(let failure):
                self?.addMoneyFailure?(failure.message)
            }
        }
    }
    
    func increaseMoneyAmount(amount: Int) -> Double {
        let currentPlanValue = account.planValue ?? 0
        let newPlanValue = currentPlanValue + 10
        account.planValue = newPlanValue
        return newPlanValue
    }
}
