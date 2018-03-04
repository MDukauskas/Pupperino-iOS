//
//  AppDelegate.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = MainViewController.tabBarController
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func rootTabBarViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [MainViewController.tabBarController,
                                            CreateExerciseViewController.tabBarController,
                                            ExerciseListViewController.tabBarController,
                                            VetListViewController.tabBarController]
        return tabBarController
    }
}
