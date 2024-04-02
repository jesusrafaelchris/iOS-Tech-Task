import UIKit

extension UIColor {
    static let accent = UIColor(named: "AccentColor")
    static let border = UIColor(red: 0.70, green: 0.81, blue: 0.84, alpha: 1.00)
    static let secondary = UIColor(red: 0.40, green: 0.63, blue: 0.67, alpha: 1.00)
    static let darkAccent = UIColor(red: 0.00, green: 0.27, blue: 0.39, alpha: 1.00)
    static let mediumAccent = UIColor(red: 0.29, green: 0.56, blue: 0.62, alpha: 1.00)
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
