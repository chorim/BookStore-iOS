import UIKit
import BookStoreKit
import BookStoreUI
import RIBs

let Logger = App.logger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private var launchRouter: LaunchRouting?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    launchRouter = RootBuilder(dependency: AppComponent()).build()
    launchRouter?.launch(from: window!)
    Logger.info("LaunchRouter has be launch")
    return true
  }
  
}
