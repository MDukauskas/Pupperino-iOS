//
//  ArticleEntityMock.swift
//  MVC SampleProject
//
//  Created by Admin on 28/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
class ArticleEntityMock: ArticleEntity {

    // MARK: - Declarations
    static private(set) var articleListFilteredBy_callsCount: Int = 0
    static private(set) var articleListFilteredBy_listParameterValue: [ArticleEntity]?
    static private(set) var articleListFilteredBy_searchParameterValue: String?
    static var articleListFilteredBy_overridenReturnValue: [ArticleEntity]? // if nil, will use original
    
    static private(set) var articleListSortedBy_callsCount: Int = 0
    static private(set) var articleListSortedBy_listParameterValue: [ArticleEntity]?
    static private(set) var articleListSortedBy_sortTypeParameterValue: ArticleEntitySortType?
    static var articleListSortedBy_overridenReturnValue: [ArticleEntity]? // if nil, will use original
    
    // MARK: - Methods
    // MARK: - Overriding ArticleEntity
    
    override class func articleList(_ articleList: [ArticleEntity], filteredBy searchText: String) -> [ArticleEntity] {
        articleListFilteredBy_callsCount += 1
        articleListFilteredBy_listParameterValue = articleList
        articleListFilteredBy_searchParameterValue = searchText
        
        if let articleListFilteredBy_overridenReturnValue = articleListFilteredBy_overridenReturnValue {
            return articleListFilteredBy_overridenReturnValue
        } else {
            return super.articleList(articleList, filteredBy: searchText)
        }
    }
    
    override class func articleList(_ articleList: [ArticleEntity], sortedBy sortType: ArticleEntitySortType) -> [ArticleEntity] {
        articleListSortedBy_callsCount += 1
        articleListSortedBy_listParameterValue = articleList
        articleListSortedBy_sortTypeParameterValue = sortType
        
        if let articleListSortedBy_overridenReturnValue = articleListSortedBy_overridenReturnValue {
            return articleListSortedBy_overridenReturnValue
        } else {
            return super.articleList(articleList, sortedBy: sortType)
        }
    }
    
    // MARK: - Public helpers
    
    class func resetMockupData() {
        articleListFilteredBy_callsCount = 0
        articleListFilteredBy_listParameterValue = nil
        articleListFilteredBy_searchParameterValue = nil
        articleListFilteredBy_overridenReturnValue = nil
        
        articleListSortedBy_callsCount = 0
        articleListSortedBy_listParameterValue = nil
        articleListSortedBy_sortTypeParameterValue = nil
        articleListSortedBy_overridenReturnValue = nil
    }
}
// swiftlint:enable identifier_name
