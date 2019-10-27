//
//  AppDelegate.swift
//  GoogleLoginDemo
//
//  Created by Иван Барабанщиков on 10/23/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // GSI. Configure the GIDSignIn shared instance and set the sign-in delegate.
        GIDSignIn.sharedInstance().clientID = "953352529496-b9rgc2f4cu2a7p9llaokqqeq8cs09cgu.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = GoogleAuthManager.instance
        
        coordinator = AppCoordinator()
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // GSI. Implement application:openURL:options: method. The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

