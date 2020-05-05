//
//  AppDelegate.swift
//  Happy TimeCalc
//
//  Created by David Pai on 2020/4/29.
//  Copyright © 2020 Pai Bros. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {

    var window: UIWindow?

//    var soundSetting = true
//    var supportDarkMode = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        window = UIWindow()
//        window?.rootViewController = ViewController()
//        window?.makeKeyAndVisible()
        
//        if UserDefaults.standard.value(forKey: "sound") == nil {
//            UserDefaults.standard.set(true, forKey: "sound")
//        }
//        soundSetting = UserDefaults.standard.bool(forKey: "sound")
//        
//        if UserDefaults.standard.value(forKey: "supportDarkMode") == nil {
//            UserDefaults.standard.set(true, forKey: "supportDarkMode")
//        }
//        supportDarkMode = UserDefaults.standard.bool(forKey: "supportDarkMode")
//        
//        if #available(iOS 13.0, *) {
//            if !supportDarkMode {
//                window?.overrideUserInterfaceStyle = .light
//            }
//            else {
//                window?.overrideUserInterfaceStyle = .unspecified
//            }
//        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

