import UIKit

extension String {
    func attributedAccountBalance(biggerFontSize: CGFloat, smallerFontSize: CGFloat) -> NSAttributedString {
        
        let components = self.components(separatedBy: ".")
        
        let firstPartAttributedString = NSMutableAttributedString(string: components[0], attributes: [.font: UIFont.boldSystemFont(ofSize: biggerFontSize)])
        
        if components.count > 1 {
            let secondPartAttributedString = NSMutableAttributedString(string: "." + components[1], attributes: [.font: UIFont.boldSystemFont(ofSize: smallerFontSize)])
            
            firstPartAttributedString.append(secondPartAttributedString)
        }
        
        if let firstCharRange = self.range(of: String(self.prefix(1))) {
            let nsRange = NSRange(firstCharRange, in: self)
            firstPartAttributedString.setAttributes([.font: UIFont.boldSystemFont(ofSize: smallerFontSize)], range: nsRange)
        }
        
        return firstPartAttributedString
    }
}
