//
//  SourceEntity.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class SourceEntity {

    // MARK: - Declarations
    var id: String = ""
    var name: String?
    var description: String?
    var url: URL!
    
    // MARK: - Methods
    convenience init?(withDictionary dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String else {
            log("WARNING! dictionary is missing id - \(dictionary)")
            return nil
        }
        
        self.init()
        self.id = id
        
        name = dictionary["name"] as? String
        description = dictionary["description"] as? String
        
        if let urlString = dictionary["url"] as? String {
            url = URL(string: urlString)
        }
    }
}
