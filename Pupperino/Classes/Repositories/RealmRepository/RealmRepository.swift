//
//  RealmRepository.swift
//  MVC SampleProject
//
//  Created by Admin on 02/03/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRepository: RepositoryProtocol {
    
    // MARK: - Constants
    private let kDatabaseFileName: String = "database"
    private let kDatabaseFileExtension: String = "realm"
    
    static var sharedRepository = RealmRepository()
    
    // MARK: - Methods -
    init() {
        setupDataBase()
    }
    
    private func setupDataBase() {
        var configuration = Realm.Configuration()
        
        // Update configuration with proper file name
        let dbFileUrl = configuration.fileURL?
            .deletingPathExtension()
            .deletingLastPathComponent()
            .appendingPathComponent(kDatabaseFileName)
            .appendingPathExtension(kDatabaseFileExtension)
        
        configuration.fileURL = dbFileUrl
        Realm.Configuration.defaultConfiguration = configuration
        
        // exclude from iCloud flag
        do {
            _ = try Realm() // forces to create file
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try configuration.fileURL?.setResourceValues(resourceValues)
        } catch {
            log("ERROR! \(error)")
        }
    }
    
    private func createRealm() -> Realm? {
        // A new realm instance is required for different thread.
        // NOTE: as instances are cached internally, creating them `produces limited overhead`
        do {
            return try Realm()
        } catch {
            log("ERROR! while creating realm instance \(error)")
        }
        return nil
    }
    
    // MARK: - RepositoryProtocol
    
    func addFavouriteArticle(_ article: ArticleEntity) {
        guard let realm = createRealm() else {
            log("WARNING: can not create realm instance")
            return
        }

        let realmArticle = ArticleRealmEntity(withArticle: article)
        var isSuccessful: Bool = false
        do {
            try realm.write {
                realm.add(realmArticle)
                isSuccessful = true
            }
        } catch {
            log("ERROR: \(error)")
        }
        
        if isSuccessful {
            notificationManager().postNotificationArticleFavouriteStatusHasChanged(article, sender: self)
        }
    }
    
    func removeFavouriteArticle(_ article: ArticleEntity) {
        guard let realm = createRealm() else {
            log("WARNING: can not create realm instance")
            return
        }
        
        guard let realmArticle = realmArticleForArticle(article) else {
            log("WARNING: could not find artilce \(article)")
            return
        }
        
        var isSuccessful: Bool = false
        do {
            try realm.write {
                realm.delete(realmArticle)
                isSuccessful = true
            }
        } catch {
            log("ERROR: \(error)")
        }
        
        if isSuccessful {
            notificationManager().postNotificationArticleFavouriteStatusHasChanged(article, sender: self)
        }
    }
    
    func favouriteArticleList() -> [ArticleEntity] {
        guard let realm = createRealm() else {
            print("WARNING: can not create realm instance")
            return []
        }
        
        return realm.objects(ArticleRealmEntity.self).flatMap({ $0.article() })
    }
    
    func isFavouriteArticle(_ article: ArticleEntity) -> Bool {
        guard let realm = createRealm() else {
            print("WARNING: can not create realm instance")
            return false
        }
        
        if realm.objects(ArticleRealmEntity.self).filter("url = %@", article.url.absoluteString).first != nil {
            return true
        }
        return false
    }
    
    // MARK: - Helpers
    
    func realmArticleForArticle(_ article: ArticleEntity) -> ArticleRealmEntity? {
        guard let realm = createRealm() else {
            print("WARNING: can not create realm instance")
            return nil
        }
        
        return realm.objects(ArticleRealmEntity.self).filter("url = %@", article.url.absoluteString).first
    }
    
    private func notificationManager() -> NotificationManager {
        return NotificationManager.sharedManager
    }
}
