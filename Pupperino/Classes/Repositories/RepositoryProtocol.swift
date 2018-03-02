//
//  DatabaseRepositoryProtocol.swift
//  MVC SampleProject
//
//  Created by Admin on 02/03/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    
    // MARK: - Favourite Articles
    func addFavouriteArticle(_ article: ArticleEntity)
    func removeFavouriteArticle(_ article: ArticleEntity)
    func favouriteArticleList() -> [ArticleEntity]
    func isFavouriteArticle(_ article: ArticleEntity) -> Bool
}
