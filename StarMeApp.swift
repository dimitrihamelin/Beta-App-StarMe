//
//  StarMeApp.swift
//  StarMe
//
//  Created by Dimitri Hamelin on 15/01/2024.
//

import SwiftUI
import Firebase

@main
struct StarMeApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    print("Yes")
    return true
  }
}

//For connecting with FireBase 
