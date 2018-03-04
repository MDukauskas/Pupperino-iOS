
//
//  DogProfileViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 04/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit
import WebKit

class DogProfileViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bobikas".localized
        
        webView.navigationDelegate = self
        let url = URL(string: "http://www.cvinfo.lt/dog-profile")
        let urlRequest = URLRequest(url: url!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(urlRequest)
    }
    
    // MARK: - UITabBar controller
    static var tabBarController: UIViewController {
        let trackerViewController = MessageListViewController()
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        navigationController.tabBarItem.title = "Bobikas".localized
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "tabbar_favorite_icon")
        return navigationController
    }
}

extension DogProfileViewController: WKNavigationDelegate {
    
}
