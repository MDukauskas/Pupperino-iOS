//
//  BaseViewController.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit
import PureLayout

//
// Contains functionality that is common to all view controllers.
//

class BaseViewController: UIViewController {
    
    // MARK: - Constants
    let kActivityIndicatorBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
    
    // MARK: - Declarations
    private var activityIndicator: UIActivityIndicatorView?

    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Activity indicator
    
    func showActivityIndicator() {
        createActivityIndicatorIfNecessary()

        guard let activityIndicator = activityIndicator else {
            log("WARNING: activityIndicator is still nil")
            return
        }
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideActivityIndicator() {
        
        guard let activityIndicator = activityIndicator else {
            log("WARNING: activityIndicator is nil")
            return
        }
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func createActivityIndicatorIfNecessary() {
        
        guard self.activityIndicator == nil else {
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        view.addSubview(activityIndicator)
        activityIndicator.autoPinEdgesToSuperviewEdges()
        activityIndicator.backgroundColor = kActivityIndicatorBackgroundColor
        
        self.activityIndicator = activityIndicator
    }
    
    // MARK: - Alerts
    
    func showAlertForGenericNetworkError() {
        
        let alertController = UIAlertController(title: "Error".localized, message: "Please check internet connection and try again".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelTitle = "Ok".localized
        let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
