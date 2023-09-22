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
  let argumentsScreen = ProcessInfo.processInfo.environment["SCREEN"]
  let argumentsTest = ProcessInfo.processInfo.environment["ENV"]
  @ViewBuilder
  var test: some View {
    if argumentsScreen == "HOME" {
      HomeScreen()
    } else {
      SigIn()
    }
  }

  var body: some Scene {
    WindowGroup {
      if argumentsTest == "TEST" {
        test
      } else {
        SigIn()
      }
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
