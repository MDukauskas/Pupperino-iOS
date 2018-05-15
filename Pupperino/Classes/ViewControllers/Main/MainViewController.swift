//
//  MainViewController.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 03/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import UIKit
import WebKit

final class MainViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Bobikas"
        
        setupNavigationBar()
        setupWebView()
    }
    
    // MARK: - UI Setup
    private func setupWebView() {
        let url = URL(string: "http://www.cvinfo.lt/dashboards")
        let urlRequest = URLRequest(url: url!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(urlRequest)
    }
    
    private func setupNavigationBar() {
        let dogImage = #imageLiteral(resourceName: "bobikas")
        let dogImageView = UIImageView(image: dogImage)
        let dogButton = UIButton(type: .custom)
        dogButton.addTarget(self, action: #selector(touchUpInsideDogProfileButton), for: .touchUpInside)
        dogButton.addSubview(dogImageView)
        dogButton.clipsToBounds = true
        dogButton.layer.cornerRadius = 16
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dogButton)
        
        setupFacebookLogin()
    }
    
    private func setupFacebookLogin() {
        navigationItem.leftBarButtonItem = FacebookLoginManager.shared.facebookLoginButton()
    }
    
    // MARK: - Helpers
    
    // MARK: - Actions
    @objc
    private func touchUpInsideDogProfileButton() {
        let profileViewController = DogProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    // MARK: - UITabBarController
    static var tabBarController: UIViewController {
        let trackerViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: trackerViewController)
        navigationController.tabBarItem.title = "Dashboard".localized
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "tabbar_favorite_icon")
        return navigationController
    }
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return false
    }
}
