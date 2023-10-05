import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let scene = (scene as? UIWindowScene) else { return }
      let window = UIWindow(windowScene: scene)
      let navigationController = UINavigationController()

      let viewContoller = LoginViewController()
      navigationController.setViewControllers([viewContoller], animated: false)

      window.rootViewController = navigationController
      window.makeKeyAndVisible()

      self.window = window
    }
}
