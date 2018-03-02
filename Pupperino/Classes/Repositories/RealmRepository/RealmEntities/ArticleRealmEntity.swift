//
//  ArticleRealmEntity.swift
//  MVC SampleProject
//
//  Created by Admin on 02/03/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleRealmEntity: Object {

    // MARK: - Declarations
    @objc dynamic var authorName: String?
    @objc dynamic var title: String?
    @objc dynamic var articleDescription: String?
    @objc dynamic var url: String?
    @objc dynamic var imageURL: String?
    @objc dynamic var publishDate: Date?
    
    // MARK: - Methods
    
    convenience init(withArticle article: ArticleEntity) {
        self.init()
        
        authorName = article.authorName
        title = article.title
        articleDescription = article.description
        url = article.url.absoluteString
        imageURL = article.imageURL?.absoluteString
        publishDate = article.publishDate
    }
    
    // MARK: - Public
    
    func article() -> ArticleEntity? {
        
        guard let articleUrlString = url else {
            log("WARNING: url is nil \(self)")
            return nil
        }
        
        let article = ArticleEntity()
        
        article.authorName = authorName
        article.title = title
        article.description = articleDescription
        article.url = URL(string: articleUrlString)
        article.imageURL = URL(string: imageURL ?? "")
        article.publishDate = publishDate

        return article
    }
}
