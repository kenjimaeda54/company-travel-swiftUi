//
//  Company_TravelApp.swift
//  Company Travel
//
//  Created by kenjimaeda on 10/09/23.
//

import FirebaseCore
import SwiftUI

@main
struct Company_TravelApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      RootView()
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
