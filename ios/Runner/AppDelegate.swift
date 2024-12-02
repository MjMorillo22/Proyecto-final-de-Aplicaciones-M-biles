import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
 override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAjF4TWNgVuYBlKfn2jDJILScdWrUQ8UL0")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
