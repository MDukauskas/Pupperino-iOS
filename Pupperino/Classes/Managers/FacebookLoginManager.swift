//
//  FacebookLoginManager.swift
//  Pupperino
//
//  Created by Paulius Cesekas on 15/03/2018.
//  Copyright © 2018 StudioLitas. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class FacebookLoginManager {
    // MARK: - Declarations
    static var shared = FacebookLoginManager()

    private let fbLoginManager = FBSDKLoginManager()

    private var _facebookLoginButton: UIBarButtonItem!

    // MARK: - Data access
    func facebookLoginButton() -> UIBarButtonItem {
        if _facebookLoginButton == nil {
            _facebookLoginButton = UIBarButtonItem(title: "Login",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpInsideFacebookLoginButton))
        }
        return _facebookLoginButton
    }

    // MARK: - Methods
    private func updateFacebookLoginButtonTitle() {
        if (FBSDKAccessToken.current() == nil) {
            facebookLoginButton().title = "Login"
        } else {
            facebookLoginButton().title = "Logout"
        }
    }

    // MARK: - Actions
    @objc
    private func touchUpInsideFacebookLoginButton() {
        guard FBSDKAccessToken.current() == nil else {
            fbLoginManager.logOut()
            print("FB logged out")
            updateFacebookLoginButtonTitle()
            return
        }
        
        let permissions = ["public_profile", "email"]
        fbLoginManager.logIn(withReadPermissions: permissions, from: UIApplication.topViewController()) {
            [weak self] (result, error) in
            self?.handleFacebookLogin(result: result, error: error)
        }
    }
    
    // MARK: - Helpers
    private func handleFacebookLogin(result: FBSDKLoginManagerLoginResult?, error: Error?) {
        guard error == nil else {
            print("FB login failed with error - \(error!.localizedDescription)")
            return
        }
        
        guard let result = result else {
            print("FB login failed with no result")
            return
        }
        
        if result.isCancelled {
            print("FB login was canceled")
        } else if result.declinedPermissions.count == 0 {
            print("FB logged in successfully with all permissions")
        } else {
            print("FB logged in successfully")
            print("Granted permissions - \(result.grantedPermissions)")
            print("Declined permissions - \(result.declinedPermissions)")
        }
        
        updateFacebookLoginButtonTitle()
    }
}
