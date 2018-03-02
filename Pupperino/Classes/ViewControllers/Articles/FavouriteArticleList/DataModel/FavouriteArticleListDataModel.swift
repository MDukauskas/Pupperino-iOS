//
//  FavouriteArticleListDataModel.swift
//  MVC SampleProject
//
//  Created by Admin on 27/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//
// swiftlint:disable file_length

import UIKit

protocol FavouriteArticleListDataModelDelegate: class {
    
    func favouriteArticleListDataModelStartedDataLoading(_ dataModel: FavouriteArticleListDataModel)
    func favouriteArticleListDataModelFinishedDataLoading(_ dataModel: FavouriteArticleListDataModel)
    
    func favouriteArticleListDataModelDidUpdateArticleList(_ dataModel: FavouriteArticleListDataModel)
    func favouriteArticleListDataModel(_ dataModel: FavouriteArticleListDataModel, didUpdateFavouriteStatusForArticle article: ArticleEntity)
    
    func favouriteArticleListDataModel(_ dataModel: FavouriteArticleListDataModel, didRemoveArticleAt index: Int)
    func favouriteArticleListDataModel(_ dataModel: FavouriteArticleListDataModel, didAddArticleAt index: Int)
}

class FavouriteArticleListDataModel {

    // MARK: - Declarations
    fileprivate var originalArticleList: [ArticleEntity] = []
    fileprivate var adjustedArticleList: [ArticleEntity] = []
    fileprivate(set) var searchText: String = ""
    fileprivate(set) var sortType: ArticleEntitySortType?
    
    private var notificationCenter = NotificationCenter()
    
    fileprivate var favouriteStatusChangingArticleList: [ArticleEntity] = []
    fileprivate var operationQueue = OperationQueue()
    
    // list to use
    var articleList: [ArticleEntity] {
        if searchText.isEmpty && sortType == nil {
            return originalArticleList
        } else {
            return adjustedArticleList
        }
    }
    
    fileprivate weak var delegate: FavouriteArticleListDataModelDelegate?
    
    // MARK: - Methods -
    init(delegate: FavouriteArticleListDataModelDelegate?) {
        self.delegate = delegate
        
        myNotificationCenter().addObserver(self,
                                           selector: didReceiveArticleFavouriteStatusHasChangedNotificationSelector(),
                                           name: Constants.Notifications.ArticleFavouriteStatusHasChanged.name,
                                           object: nil)
    }
    
    deinit {
        operationQueue.cancelAllOperations()
    }
    
    // MARK: - Public
    
    func loadDataIfNecessary() {
        
        delegate?.favouriteArticleListDataModelStartedDataLoading(self)
        originalArticleList = repository().favouriteArticleList()
        delegate?.favouriteArticleListDataModelFinishedDataLoading(self)
    }
    
    func articleAtIndex(_ index: Int) -> ArticleEntity? {
        
        guard index > -1, index < articleList.count else {
            log("WARNING! unexpected index \(index), while list size is \(articleList.count)")
            return nil
        }
        
        return articleList[index]
    }
    
    func setSearchText(_ searchText: String) {
        guard self.searchText != searchText else {
            return
        }

        self.searchText = searchText

        updateAdjustedArticleList()
        delegate?.favouriteArticleListDataModelDidUpdateArticleList(self)
    }
    
    func setSortType(_ sortType: ArticleEntitySortType?) {
        guard self.sortType != sortType else {
            return
        }

        self.sortType = sortType

        updateAdjustedArticleList()
        delegate?.favouriteArticleListDataModelDidUpdateArticleList(self)
    }
    
    func favouriteStatusOfArticle(_ article: ArticleEntity) -> ArticleFavouriteStatus {
        
        if favouriteStatusChangingArticleList.contains(article) {
            return .favouriteStatusIsChanging
        }
        
        if originalArticleList.contains(article) {
            return .favourite
        }
        
        return .notFavourite
    }
    
    func unfavouriteArticle(_ article: ArticleEntity) {
        
        guard originalArticleList.contains(article) else {
            log("WARNING: article \(article) does not belong to list \(originalArticleList)")
            return
        }
        
        guard favouriteStatusChangingArticleList.contains(article) == false else {
            // we are already updating status
            return
        }
        
        favouriteStatusChangingArticleList.append(article)
        delegate?.favouriteArticleListDataModel(self, didUpdateFavouriteStatusForArticle: article)
        
        let changeArticleFavouriteStatusInput = ChangeArticleFavouriteStatusInput(withArticle: article)
        let changeArticleFavouriteStatusOperation = ChangeArticleFavouriteStatusOperation(withInput: changeArticleFavouriteStatusInput)
        changeArticleFavouriteStatusOperation.completionBlock = { [weak self] in
            self?.didFinishChangeArticleFavouriteStatusOperation(changeArticleFavouriteStatusOperation)
        }
        
        operationQueue.addOperation(changeArticleFavouriteStatusOperation)
    }
    
    fileprivate func didFinishChangeArticleFavouriteStatusOperation(_ operation: ChangeArticleFavouriteStatusOperation) {
        // is expected to be called only for removing article
        dispatch_main_sync_safe {
            
            let article: ArticleEntity = operation.input().article
            self.favouriteStatusChangingArticleList.remove(object: article)
            
            if operation.output.isSuccessful {
                self.repository().removeFavouriteArticle(article)
                self.removeArticleFromFavouriteList(article)
            } else {
                // Must update article faourite state
                self.delegate?.favouriteArticleListDataModel(self, didUpdateFavouriteStatusForArticle: article)
            }
        }
    }

    // MARK: - Getters
    
    fileprivate func myNotificationCenter() -> NotificationCenter {
        return NotificationCenter.default
    }
    
    fileprivate func repository() -> RepositoryProtocol {
        return RepositoryFactory.repository
    }
    
    fileprivate func articleEntityType() -> ArticleEntity.Type {
        return ArticleEntity.self
    }
    
    fileprivate func didReceiveArticleFavouriteStatusHasChangedNotificationSelector() -> Selector {
        return #selector(didReceiveArticleFavouriteStatusHasChangedNotification(_:))
    }
    
    // MARK: - Notifications
    
    @objc fileprivate func didReceiveArticleFavouriteStatusHasChangedNotification(_ notification: Notification) {
        
        guard let article = NotificationManager.sharedManager.articleFromFavouriteStatusHasChangedNotification(notification) else {
            log("WARNING! notification does not contain article \(notification)")
            return
        }
        
        if repository().isFavouriteArticle(article) {
            addNewArticleToFavouriteList(article)
        } else {
            removeArticleFromFavouriteList(article)
        }
    }
    
    // MARK: - Article List adjustment
    
    fileprivate func updateAdjustedArticleList() {
        
        guard originalArticleList.isEmpty == false else {
            adjustedArticleList = []
            return
        }
        
        var updatedList: [ArticleEntity] = originalArticleList
        
        if searchText.isEmpty == false {
            updatedList = articleEntityType().articleList(updatedList, filteredBy: searchText)
        }
        
        if let sortType = sortType {
            updatedList = articleEntityType().articleList(updatedList, sortedBy: sortType)
        }
        
        adjustedArticleList = updatedList
    }
    
    fileprivate func addNewArticleToFavouriteList(_ article: ArticleEntity) {
        
        guard originalArticleList.contains(article) == false else {
            return
        }
        
        originalArticleList.append(article)
        updateAdjustedArticleList()
        
        let index = articleList.index(of: article)
        if let index = index {
            delegate?.favouriteArticleListDataModel(self, didAddArticleAt: index)
        }
    }
    
    fileprivate func removeArticleFromFavouriteList(_ article: ArticleEntity) {
        
        guard let originalListIndex = originalArticleList.index(of: article) else {
            return
        }
        
        let articleListIndex: Int? = articleList.index(of: article)
        originalArticleList.remove(at: originalListIndex)
        updateAdjustedArticleList()
        
        if let articleListIndex = articleListIndex {
            delegate?.favouriteArticleListDataModel(self, didRemoveArticleAt: articleListIndex)
        }
    }
}

