//
//  MessageListViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 04/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit
import WebKit

class MessageListViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Messages".localized
        
        webView.navigationDelegate = self
        let url = URL(string: "https://pupperino-1520023802809.firebaseapp.com/#!/?username=Bobikas")
        let urlRequest = URLRequest(url: url!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(urlRequest)
    }

    // MARK: - UITabBar controller
    static var tabBarController: UIViewController {
        let trackerViewController = MessageListViewController()
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        navigationController.tabBarItem.title = "Messages".localized
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "tabbar_favorite_icon")
        return navigationController
    }
}

extension MessageListViewController: WKNavigationDelegate {
    
}
