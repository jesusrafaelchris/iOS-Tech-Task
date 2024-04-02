import UIKit

extension Double {

    func formattedBalance(
        biggerFontSize: CGFloat,
        smallerFontSize: CGFloat
    ) -> NSAttributedString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2

        let result = formatter.string(from: NSNumber(value: self)) ?? ""
        
        return result.attributedAccountBalance(biggerFontSize: biggerFontSize, smallerFontSize: smallerFontSize)
    }
}
