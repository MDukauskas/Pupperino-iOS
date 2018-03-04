//
//  UIView+AutoLayouts.swift
//  SpentTravel
//
//  Created by Tomas Urbonas on 20/06/2017.
//  Copyright © 2017 Receiptless Software. All rights reserved.
//

import UIKit


extension UIView {
    
    func pinViewToEdgesOf(parentView: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
