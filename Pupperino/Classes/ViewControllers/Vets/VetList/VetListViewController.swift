//
//  VetListViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 04/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit
import WebKit

class VetListViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Vet List".localized
        
        webView.navigationDelegate = self
        let url = URL(string: "http://www.cvinfo.lt/vet-list")
        let urlRequest = URLRequest(url: url!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(urlRequest)
    }
    
    // MARK: - UITabBar controller
    static var tabBarController: UIViewController {
        let trackerViewController = VetListViewController()
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        navigationController.tabBarItem.title = "Vet List".localized
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "tabbar_favorite_icon")
        return navigationController
    }
}

extension VetListViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString,
            urlString.contains("?open") else {
                return
        }

        openMessages()
    }
    
    private func openMessages() {
        let messagesViewController = MessageListViewController()
        navigationController?.pushViewController(messagesViewController, animated: true)
    }
}

