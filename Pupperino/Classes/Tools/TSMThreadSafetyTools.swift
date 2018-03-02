//
//  TSMThreadSafetyTools.swift
//
//  Global functions to deal with thread safety issues.
//

import Foundation

// MARK: - Main Thread
func dispatch_main_sync_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread {
        callback()
    } else {
        DispatchQueue.main.sync {
            callback()
        }
    }
}

func dispatch_main_async_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread {
        callback()
    } else {
        DispatchQueue.main.async {
            callback()
        }
    }
}

// MARK: - Background Thread
func dispatch_background_sync_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread == false {
        callback()
    } else {
        DispatchQueue.global().sync {
            callback()
        }
    }
}

func dispatch_background_async_safe(_ callback: @escaping () -> Void) {
    
    if Thread.isMainThread == false {
        callback()
    } else {
        DispatchQueue.global().async {
            callback()
        }
    }
}

// MARK: - Synchronized
func synchronized(_ object: Any, _ callback: () -> Void) {
    // @synchronized in obj-c
    // To be used to safeguard object instances that may be used from several threads
    objc_sync_enter(object)
    callback()
    objc_sync_exit(object)
}
