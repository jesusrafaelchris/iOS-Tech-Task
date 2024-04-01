import UIKit
import Networking

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let sessionManager = SessionManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if sessionManager.isUserLoggedIn {
            window.rootViewController = UINavigationController(
                rootViewController: AccountsViewController(viewModel: AccountsViewModel(dataProvider: DataProvider(), sessionManager: SessionManager()))
            )
        } else {
            window.rootViewController =  UINavigationController(
                rootViewController: LoginViewController(viewModel: LoginViewModel(dataProvider: DataProvider(), sessionManager: SessionManager()))
                )
        }

        self.window = window
        window.makeKeyAndVisible()
    }
}
