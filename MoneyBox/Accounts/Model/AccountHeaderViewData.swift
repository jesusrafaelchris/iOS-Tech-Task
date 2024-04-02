import Foundation

struct AccountHeaderViewData {
    var greeting: String
    var totalPlanValue: Double?
    var totalEarnings: Double?
    var totalContributionsNet: Double?
    var totalEarningsAsPercentage: Double?
    
    var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2

        let result = formatter.string(from: NSNumber(value: totalPlanValue ?? 0)) ?? ""
        return result
    }
    
    var formattedTotalValue: NSAttributedString {
        formattedTotal.attributedAccountBalance(biggerFontSize: 40, smallerFontSize: 20)
    }
}
