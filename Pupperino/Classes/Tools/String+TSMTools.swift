//
//  String+TSMTools.swift
//
//  * Generic tools
//  * Validation tools
//  * Optional string
//

import UIKit

extension String {
    
    // MARK: - Generic tools
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var length: Int {
        return self.count
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }

    // MARK: - Validation
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isContainOnlyNumbers() -> Bool { // TODO: fix
        
        let stringWithNumbersOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        return (self.length == stringWithNumbersOnly.length)
    }
    
    // MARK: - Appending Path
    func append(pathComponent path: String?) -> String {
        
        guard let path = path else {
            return self
        }
        
        let string = self as NSString
        let appendedString: String = string.appendingPathComponent(path)
        
        return appendedString
    }
    
    func append(relativePathParameters parameters: [String: Any]?) -> String {
        // NOTE: if using to generate URL, look into `URLComponents`
        guard let parameters = parameters else {
            return self
        }
        
        let parametersString: NSMutableString = NSMutableString()
        var parametersCount: Int = 0
        
        for (key, value) in parameters {
            
            parametersCount += 1
            parametersString.append((parametersCount == 1) ? "?" : "&")
            parametersString.append("\(key)=\(value)")
        }
        
        let constructedPath: String = self.appending(parametersString as String)
        return constructedPath
    }
}

// MARK: - Optional String -

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}
