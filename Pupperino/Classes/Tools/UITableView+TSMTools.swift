//
//  UITableView+TSMTools.swift
//
//  Is dependent on `TSMGenericTools`
//

import UIKit

extension UITableView {
    
    public func registerCellNib<T: UITableViewCell>(withType type: T.Type) {
        
        guard let identifier: String = classNameFromClass(type) else {
            log("WARNING! could not make class name from type \(type)")
            return
        }
        
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        
        guard let identifier: String = classNameFromClass(T.self) else {
            log("WARNING! could not make class name from type \(T.self)")
            return nil
        }
        
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
        return cell
    }
    
    public func dequeueReusableCell<T: UITableViewCell>() -> T? {
        
        guard let identifier: String = classNameFromClass(T.self) else {
            log("WARNING! could not make class name from type \(T.self)")
            return nil
        }
        
        let cell = dequeueReusableCell(withIdentifier: identifier) as? T
        return cell
    }
}
