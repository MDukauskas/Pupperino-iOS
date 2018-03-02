//
//  GenericTools.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class GenericTools {

    static var apiDateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = Constants.DateFormatters.BackEndServer.dateFormat
        
        return dateFormatter
    }()
    
    static var commonDateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = Constants.DateFormatters.Default.dateFormat
        
        return dateFormatter
    }()
    
    // MARK: - Random generator
    
    static func randomNumberWithMaxValue(_ maxValue: UInt32) -> UInt32 {
        // NOTE: min value is always 0        
        return arc4random_uniform(maxValue + 1)
    }
}
