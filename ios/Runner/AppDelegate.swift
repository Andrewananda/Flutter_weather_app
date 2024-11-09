import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      
      if #available(iOS 13.0, *) {
          let statusBarStyle: UIStatusBarStyle = .lightContent // Change to .darkContent if you prefer dark icons
          UINavigationBar.appearance().barStyle = statusBarStyle == .lightContent ? .black : .default
      } else {
          UIApplication.shared.statusBarStyle = .lightContent
      }
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
