//
//  UIApplication+TopViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 15/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow,
            let windowRootViewController = window.rootViewController else {
            return nil
        }
        return topViewController(for:windowRootViewController)
    }
    
    static func topViewController(for baseViewController: UIViewController) -> UIViewController {
        if let baseViewController = baseViewController as? UINavigationController {
            if let visibleViewController = baseViewController.visibleViewController {
                return topViewController(for:visibleViewController)
            } else {
                return baseViewController
            }
        }
        
        if let baseViewController = baseViewController as? UITabBarController {
            if let selectedViewController = baseViewController.selectedViewController {
                return topViewController(for:selectedViewController)
            } else {
                return baseViewController
            }
        }

        if let presentedViewController = baseViewController.presentedViewController {
            return topViewController(for:presentedViewController)
        }
    
        return baseViewController
    }
}
