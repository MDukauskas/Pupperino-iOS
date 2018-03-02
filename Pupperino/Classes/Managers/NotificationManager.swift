//
//  NotificationManager.swift
//  MVC SampleProject
//
//  Created by Admin on 27/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class NotificationManager {

    // MARK: - Declarations
    static var sharedManager = NotificationManager()
    
    // MARK: - Methods
    // MARK: - Public - ArticleFavouriteStatusHasChanged
    
    func postNotificationArticleFavouriteStatusHasChanged(_ article: ArticleEntity, sender: Any?) {
        
        dispatch_main_sync_safe {
            let notification = self.notificationArticleFavouriteStatusHasChanged(article, sender: sender)
            NotificationCenter.default.post(notification)
        }
    }
    
    func notificationArticleFavouriteStatusHasChanged(_ article: ArticleEntity, sender: Any?) -> Notification {
        
        var userInfo: [AnyHashable: Any] = [:]
        userInfo[Constants.Notifications.ArticleFavouriteStatusHasChanged.articleUserInfoKey] = article
        
        let notification = Notification(name: Constants.Notifications.ArticleFavouriteStatusHasChanged.name,
                                        object: sender,
                                        userInfo: userInfo)
        return notification
    }
    
    func articleFromFavouriteStatusHasChangedNotification(_ notification: Notification) -> ArticleEntity? {
        
        guard notification.name == Constants.Notifications.ArticleFavouriteStatusHasChanged.name else {
            log("WARNING! unexpected notification name \(notification.name)")
            return nil
        }
        
        return notification.userInfo?[Constants.Notifications.ArticleFavouriteStatusHasChanged.articleUserInfoKey] as? ArticleEntity
    }
}
