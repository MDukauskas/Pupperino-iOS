//
//  ArticleEntity.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

enum ArticleEntitySortType {
    case publishDate
    case author
    case title
}

class ArticleEntity: Equatable {

    // MARK: - Declarations
    var authorName: String?
    var title: String?
    var description: String?
    var url: URL!
    var imageURL: URL?
    var publishDate: Date?
    
    // MARK: - Methods -
    convenience init?(withDictionary dictionary: [String: Any]) {
        
        guard let urlString = dictionary["url"] as? String,
        let url = URL(string: urlString) else {
            log("WARNING! dictionary is missing url - \(dictionary)")
            return nil
        }
        
        self.init()
        self.url = url
        
        authorName = dictionary["author"] as? String
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        
        if let imageUrlString = dictionary["urlToImage"] as? String {
            imageURL = URL(string: imageUrlString)
        }
        
        if let publishDateString = dictionary["publishedAt"] as? String {
            publishDate = GenericTools.apiDateFormatter.date(from: publishDateString)
        }
    }
    
    // MARK: - Equatable
    
    static func == (lhs: ArticleEntity, rhs: ArticleEntity) -> Bool {
        return lhs.url == rhs.url
    }
    
    // MARK: - Public
    
    func doesTitleOrDescriptionContainText(_ searchText: String) -> Bool {
        
        if let title = title, title.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
            return true
        }
        
        if let description = description, description.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
            return true
        }
        
        return false
    }
    
    // MARK: - Tools
    
    class func articleList(_ articleList: [ArticleEntity], filteredBy searchText: String) -> [ArticleEntity] {
        // Filters by `Title` and `Description` using provided `searchText`
        
        guard searchText.isEmpty == false else {
            return articleList
        }
        
        return articleList.filter({ (article: ArticleEntity) -> Bool in
            return article.doesTitleOrDescriptionContainText(searchText)
        })
    }
    
    class func articleList(_ articleList: [ArticleEntity], sortedBy sortType: ArticleEntitySortType) -> [ArticleEntity] {
        var sortedList = articleList
        
        switch sortType {
        case .publishDate:
            sortedList = self.articleListSortedByPublishDate(articleList)
            
        case .author:
            sortedList = self.articleListSortedByAuthor(articleList)
            
        case .title:
            sortedList = self.articleListSortedByTitle(articleList)
        }
        
        return sortedList
    }
    
    class func articleListSortedByPublishDate(_ articleList: [ArticleEntity]) -> [ArticleEntity] {
        return articleList.sorted { $0.publishDate ?? Date(timeIntervalSince1970: 0) > $1.publishDate ?? Date(timeIntervalSince1970: 0) }
    }
    
    class func articleListSortedByAuthor(_ articleList: [ArticleEntity]) -> [ArticleEntity] {
        return articleList.sorted { $0.authorName ?? "" < $1.authorName ?? "" }
    }
    
    class func articleListSortedByTitle(_ articleList: [ArticleEntity]) -> [ArticleEntity] {
        return articleList.sorted { $0.title ?? "" < $1.title ?? "" }
    }
}
