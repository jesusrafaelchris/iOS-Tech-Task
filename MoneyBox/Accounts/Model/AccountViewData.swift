import Foundation

struct AccountViewData {
    var totalPlanValue: Double?
    var totalEarnings: Double?
    
    var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2

        let result = formatter.string(from: NSNumber(value: totalPlanValue ?? 0)) ?? ""
        return result
    }
}
