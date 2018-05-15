//
//  AppDelegate.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit
import WebKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UINavigationBar.appearance().isTranslucent = false
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = MainViewController.tabBarController
        window.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation] as! String
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                            open: url,
                                                                            sourceApplication: sourceApplication,
                                                                            annotation: annotation)
        // Add any custom logic here.
        return handled
    }
    
    // MARK: helpers
    private func rootTabBarViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [MainViewController.tabBarController,
                                            CreateExerciseViewController.tabBarController,
                                            ExerciseListViewController.tabBarController,
                                            VetListViewController.tabBarController]
        return tabBarController
    }
}
