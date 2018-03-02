//
//  FMDBRepository.swift
//  MVC SampleProject
//
//  Created by Admin on 22/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit
import FMDB

//
// NOTE: during init, setup is being triggered which copies local db file,
//       this may take some time (depending on db file size in bundle.),
//       so bigger DB initialisation should be started on background thread,
//       as also outside -application:didFinishLaunchingWithOptions scope.
//

// swiftlint:disable line_length
class FMDBRepository: RepositoryProtocol {
    
    // MARK: - Constants
    private let kBundleDatabaseFileName = "fmdbDatabase"
    private let kBundleDatabaseFileExtension = "db"
    private let kLocalDatabaseFilename = "fmdbDatabase.db"

    // MARK: - Declarations
    static var sharedRepository = FMDBRepository()
    
    private var localDbFilePath: String!
    private var commonDbQueue: FMDatabaseQueue?
    
    // MARK: - Methods -
    init() {
        localDbFilePath = databaseFilePath()
        
        prepareLocalRepository()
    }
    
    deinit {
        if let commonDbQueue = commonDbQueue {
            commonDbQueue.close()
        }
    }
    
    // MARK: - Setup
    
    private func prepareLocalRepository() {
        
        guard FileManager.default.fileExists(atPath: localDbFilePath) == false else {
            return
        }
        
        guard let bundleDbFilePath: String = Bundle.main.path(forResource: kBundleDatabaseFileName, ofType: kBundleDatabaseFileExtension) else {
            log("WARNING! could not generate bundle file path, with name \(kBundleDatabaseFileName) and extension \(kBundleDatabaseFileExtension)")
            return
        }
        
        // Copy local file
        do {
            try FileManager.default.copyItem(atPath: bundleDbFilePath, toPath: localDbFilePath)
    
            // exclude from iCloud flag
            if var localDbFileURL = URL(string: bundleDbFilePath) {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try localDbFileURL.setResourceValues(resourceValues)
            }
        } catch {
            log("ERROR: \(error)")
        }
    }
    
    private func databaseFilePath() -> String {
        let pathList: [String] = NSSearchPathForDirectoriesInDomains( .documentDirectory, .userDomainMask, true)
    
        guard let documentDirectoryPath: String = pathList.first else {
            log("WARNING! could not get document directory path")
            return ""
        }
        
        let fullPath = documentDirectoryPath.append(pathComponent: kLocalDatabaseFilename)
        return fullPath
    }
    
    private func dbQueue() -> FMDatabaseQueue {
        
        if let commonDbQueue = commonDbQueue {
            return commonDbQueue
        }
        
        commonDbQueue = FMDatabaseQueue(path: localDbFilePath)
        // swiftlint:disable force_unwrapping
        return commonDbQueue!
        // swiftlint:enable force_unwrapping
    }
    
    // MARK: - Public - DB data
    
    func databaseVersion() -> Int? {
        var version: Int?
        
        dbQueue().inDatabase { (database: FMDatabase) in
            let resultSet: FMResultSet? = database.executeQuery("SELECT * FROM databaseInfo LIMIT 1", withArgumentsIn: [])
            
            if let resultSet = resultSet {
                version = resultSet.long(forColumn: "version")
                resultSet.close()
            } else {
                log("WARNING: result set is nil")
            }
        }
        
        return version
    }
    
    // MARK: - Public - RepositoryProtocol
    
    func addFavouriteArticle(_ article: ArticleEntity) {
        var isSuccessful: Bool = false
        
        dbQueue().inTransaction { (database: FMDatabase, rollback) in
            isSuccessful = database.executeUpdate("INSERT INTO favouriteArticles (authorName, title, description, url, imageUrl, publishDate) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsIn: [article.authorName ?? "", article.title ?? "", article.description ?? "", article.url.absoluteString, article.imageURL?.absoluteString ?? "", article.publishDate ?? NSNull()])
            
            if isSuccessful == false {
                rollback.pointee = true
                log("WARNING! Transaction for article \(article) has failed, triggering roll back")
            }
        }
        
        if isSuccessful {
            notificationManager().postNotificationArticleFavouriteStatusHasChanged(article, sender: self)
        }
    }
    
    func removeFavouriteArticle(_ article: ArticleEntity) {
        var isSuccessful: Bool = false
        
        dbQueue().inTransaction { (database: FMDatabase, rollback) in
            isSuccessful = database.executeUpdate("DELETE FROM favouriteArticles WHERE url == ?", withArgumentsIn: [article.url.absoluteString])
            
            if isSuccessful == false {
                rollback.pointee = true
                log("WARNING! Transaction for article \(article) has failed, triggering roll back")
            }
        }
        
        if isSuccessful {
            notificationManager().postNotificationArticleFavouriteStatusHasChanged(article, sender: self)
        }
    }
    
    func favouriteArticleList() -> [ArticleEntity] {
        var articleList: [ArticleEntity] = []
        
        dbQueue().inDatabase { (database: FMDatabase) in
            
            guard let resultSet: FMResultSet = database.executeQuery("SELECT * FROM favouriteArticles", withArgumentsIn: []) else {
                return
            }
            
            while resultSet.next() {
                if let article = self.articleFromFMResultSet(resultSet) {
                    articleList.append(article)
                } else {
                    log("WARNING: could not parse article, from resultSet \(resultSet)")
                }
            }
            
            resultSet.close()
        }
        
        return articleList
    }
    
    func isFavouriteArticle(_ article: ArticleEntity) -> Bool {

        var isFavourite: Bool = false
        
        dbQueue().inDatabase { (database: FMDatabase) in
            
            guard let resultSet: FMResultSet = database.executeQuery("SELECT * FROM favouriteArticles WHERE url == ? LIMIT 1", withArgumentsIn: [article.url.absoluteString]) else {
                return
            }
            
            if resultSet.next() {
                isFavourite = true
            }
            
            resultSet.close()
        }
        
        return isFavourite
    }
    
    // MARK: - Helpers
    
    private func articleFromFMResultSet(_ fmResultSet: FMResultSet) -> ArticleEntity? {
        
        guard let urlString = fmResultSet.string(forColumn: "url"), let url = URL(string: urlString) else {
            log("WARNING: could not parse url from result set \(fmResultSet)")
            return nil
        }
        
        let article = ArticleEntity()
        article.url = url
        
        article.authorName = fmResultSet.string(forColumn: "authorName")
        article.title = fmResultSet.string(forColumn: "title")
        article.description = fmResultSet.string(forColumn: "description")
        if let imageUrlString = fmResultSet.string(forColumn: "imageUrl") {
            article.imageURL = URL(string: imageUrlString)
        }
        article.publishDate = fmResultSet.date(forColumn: "publishDate")
        
        return article
    }
    
    private func notificationManager() -> NotificationManager {
        return NotificationManager.sharedManager
    }
}
// swiftlint:enable line_length
