//
//  ExerciseListViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 03/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit

class ExerciseListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Exercise List".localized
    }

    // MARK: - UITabBar controller
    static var tabBarController: UIViewController {
        let trackerViewController = ExerciseListViewController()
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        navigationController.tabBarItem.title = "Exercise List".localized
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "tabbar_favorite_icon")
        return navigationController
    }
}
