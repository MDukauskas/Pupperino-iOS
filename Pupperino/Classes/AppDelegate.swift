//
//  AppDelegate.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = rootTabBarViewController()
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func rootTabBarViewController() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        
        let trackerViewController = TrackerViewController()
        let trackerTabNavigationController = UINavigationController(rootViewController: trackerViewController)
        trackerTabNavigationController.tabBarItem.title = trackerViewController.tabBarItem.title
        trackerTabNavigationController.tabBarItem.image = trackerViewController.tabBarItem.image
        
        let sourceListViewController = SourceListViewController()
        let firstTabNavigationController = UINavigationController(rootViewController: sourceListViewController)
        firstTabNavigationController.tabBarItem.title = sourceListViewController.tabBarItem.title
        firstTabNavigationController.tabBarItem.image = sourceListViewController.tabBarItem.image
        
        let favouriteArticleListViewController = FavouriteArticleListViewController()
        let secondTabNavigationController = UINavigationController(rootViewController: favouriteArticleListViewController)
        secondTabNavigationController.tabBarItem.title = favouriteArticleListViewController.tabBarItem.title
        secondTabNavigationController.tabBarItem.image = favouriteArticleListViewController.tabBarItem.image

        tabBarController.viewControllers = [trackerTabNavigationController,
                                            firstTabNavigationController,
                                            secondTabNavigationController]
        return tabBarController
    }
}
