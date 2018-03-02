//
//  TSMGenericTools.swift
//
//  Generic tools, other tool libraries, might be dependable on this one.
//

import UIKit

/// i.e. 2018-02-06 12:50:54.689325+0200 AppName[12304:4377007] [AppDelegate.application(_:didFinishLaunchingWithOptions:) 17 <M>]: Example log
func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    let fileName = file.components(separatedBy: "/").last ?? file
    NSLog("[\((fileName as NSString).deletingPathExtension).\(function) \(line) <\((Thread.isMainThread) ? "M" : "B")>]: \(message)")
}

func loadXibFromClass(_ aClass: AnyClass) -> UIView? {
    guard let classNameString = classNameFromClass(aClass) else {
        log("WARNING: could not generate class Name string from class \(aClass)")
        return nil
    }
    return Bundle.main.loadNibNamed(classNameString, owner: nil, options: nil)?[0] as? UIView
}

func classNameFromClass(_ aClass: AnyClass) -> String? {
    // class name, make sure it does not include module name (so select only last part), e.g. from: module.className
    let callClassName: String? = NSStringFromClass(aClass).components(separatedBy: ".").last
    return callClassName
}

// MARK: - Folders

func pathOfDocumentsDirectory() -> String? {
    let paths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let path: String? = paths.first
    
    return path
}

func pathOfDocumentsDirectoryByAppending(pathComponent path: String) -> String? {
    let basePath: String? = pathOfDocumentsDirectory()
    let fullPath = basePath?.appending(path)
    
    return fullPath
}
