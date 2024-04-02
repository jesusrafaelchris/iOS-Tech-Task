import Foundation
import Networking

struct AccountHeaderViewData {
    var greeting: String
    var totalPlanValue: Double?
    var totalEarnings: Double?
    var totalContributionsNet: Double?
    var totalEarningsAsPercentage: Double?
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
