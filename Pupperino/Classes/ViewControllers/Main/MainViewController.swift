//
//  MainViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 03/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.title = "Dash".localized
        tabBarItem.image = #imageLiteral(resourceName: "tabbar_favorite_icon")
    }
}
