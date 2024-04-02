import Foundation
import Networking

struct AccountHeaderViewData {
    var greeting: String
    var totalPlanValue: Double?
    var totalEarnings: Double?
    var totalContributionsNet: Double?
    var totalEarningsAsPercentage: Double?
    let actions: [ActionModel] = [
        .init(label: "Add £1", amount: "1"),
        .init(label: "Add £2", amount: "2"),
        .init(label: "Add £5", amount: "5"),
        .init(label: "Add £10", amount: "10"),
        .init(label: "Custom", amount: "+"),
    ]
}

struct ActionModel {
    let label: String
    let amount: String
}

extension AccountResponse {
    func asViewData(greeting: String) -> AccountHeaderViewData {
        return .init(
            greeting: greeting,
            totalPlanValue: totalPlanValue,
            totalEarnings: totalEarnings,
            totalContributionsNet: totalContributionsNet,
            totalEarningsAsPercentage: totalEarningsAsPercentage
        )
    }
}
