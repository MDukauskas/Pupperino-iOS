//
//  Array+Tools.swift
//  MVC SampleProject
//
//  Created by Admin on 26/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    
    @discardableResult mutating func remove(object: Element) -> Bool {
        if let index = index(of: object) {
            self.remove(at: index)
            return true
        }
        return false
    }
}
