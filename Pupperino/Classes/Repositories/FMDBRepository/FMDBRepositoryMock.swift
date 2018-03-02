//
//  FMDBRepositoryMock.swift
//  MVC SampleProject
//
//  Created by Admin on 27/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
class FMDBRepositoryMock: FMDBRepository {
    
    // MARK: - Declarations
    var mockedFavouriteArticleList: [ArticleEntity] = []
    
    private(set) var favouriteArticleList_callCount: Int = 0
    private(set) var mockedIsFavouriteArticleList_callCount: Int = 0
    private(set) var addFavouriteArticle_callCount: Int = 0
    private(set) var addFavouriteArticle_articleParameter: ArticleEntity?
    private(set) var removeFavouriteArticle_callCount: Int = 0
    private(set) var removeFavouriteArticle_articleParameter: ArticleEntity?

    // MARK: - Overriding FMDBRepository
    
    override func favouriteArticleList() -> [ArticleEntity] {
        favouriteArticleList_callCount += 1
        return mockedFavouriteArticleList
    }
    
    override func isFavouriteArticle(_ article: ArticleEntity) -> Bool {
        mockedIsFavouriteArticleList_callCount += 1
        return mockedFavouriteArticleList.contains(article)
    }
    
    override func addFavouriteArticle(_ article: ArticleEntity) {
        addFavouriteArticle_callCount += 1
        addFavouriteArticle_articleParameter = article
    }
    
    override func removeFavouriteArticle(_ article: ArticleEntity) {
        removeFavouriteArticle_callCount += 1
        removeFavouriteArticle_articleParameter = article
    }
}
// swiftlint:enable identifier_name
