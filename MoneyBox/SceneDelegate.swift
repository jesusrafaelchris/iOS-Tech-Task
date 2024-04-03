import UIKit
import Networking

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let sessionManager = SessionManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        

        let loginViewModel = LoginViewModel()
        
        window.rootViewController = UINavigationController( rootViewController: LoginViewController(viewModel: loginViewModel)
        )
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
