import UIKit

class LoadingButton: UIButton {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActivityIndicator()
        setupA11y()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        backgroundColor = .accent
        setTitle("Log in", for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        clipsToBounds = true
        layer.cornerRadius = 8
        activityIndicator.color = .white

    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.isHidden = true
    }
    
    private func setupA11y() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = "Log in"
    }

    func showLoading() {
        setTitle(nil, for: .normal)
        accessibilityLabel = "Loading"
        isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        setTitle("Log in", for: .normal)
        isEnabled = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
