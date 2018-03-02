//
//  ArticleListDataModel.swift
//  MVC SampleProject
//
//  Created by Admin on 13/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

protocol ArticleListDataModelDelegate: class {
    
    func articleListDataModelStartedDataLoading(_ dataModel: ArticleListDataModel)
    func articleListDataModelFinishedDataLoading(_ dataModel: ArticleListDataModel)
    func articleListDataModelFailedDataLoading(_ dataModel: ArticleListDataModel)
    
    func articleListDataModelDidUpdateArticleList(_ dataModel: ArticleListDataModel)
    func articleListDataModel(_ dataModel: ArticleListDataModel, didUpdateFavouriteStatusForArticle article: ArticleEntity)
}

class ArticleListDataModel {

    // MARK: - Declarations
    private(set) var source: SourceEntity
    
    private var originalArticleList: [ArticleEntity] = []
    private var adjustedArticleList: [ArticleEntity] = []
    private(set) var searchText: String = ""
    private(set) var sortType: ArticleEntitySortType?
    
    private var favouriteStatusChangingArticleList: [ArticleEntity] = []
    
    // list to use
    var articleList: [ArticleEntity] {
        if searchText.isEmpty && sortType == nil {
            return originalArticleList
        } else {
            return adjustedArticleList
        }
    }
    
    private weak var delegate: ArticleListDataModelDelegate?
    
    private var operationQueue = OperationQueue()
    private var isDataLoadInProgress = false
    
    // MARK: - Methods -
    init(withSource source: SourceEntity, delegate: ArticleListDataModelDelegate?) {
        self.source = source
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveArticleFavouriteStatusHasChangedNotification(_:)),
                                               name: Constants.Notifications.ArticleFavouriteStatusHasChanged.name,
                                               object: nil)
    }
    
    deinit {
        operationQueue.cancelAllOperations()
    }
    
    // MARK: - Public
    
    func loadDataIfNecessary() {
        
        guard isDataLoadInProgress == false else {
            return
        }
        
        isDataLoadInProgress = true
        delegate?.articleListDataModelStartedDataLoading(self)
        
        let getArticleListInput = GetArticleListInput()
        getArticleListInput.source = source
        
        let getArticleListOperation = GetArticleListOperation(withInput: getArticleListInput)
        
        getArticleListOperation.completionBlock = { [weak self, unowned getArticleListOperation] in
            self?.didFinishGetArticleListOperation(getArticleListOperation)
        }
        
        operationQueue.addOperation(getArticleListOperation)
    }
    
    private func didFinishGetArticleListOperation(_ operation: GetArticleListOperation) {
    
        dispatch_main_sync_safe {
            self.isDataLoadInProgress = false
            
            if operation.output.isSuccessful {
                self.originalArticleList = operation.output().articleList
                self.updateAdjustedArticleList()
                
                self.delegate?.articleListDataModelFinishedDataLoading(self)
            } else {
                // operation.output.isSuccessful == false
                self.delegate?.articleListDataModelFailedDataLoading(self)
            }
        }
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
        delegate?.articleListDataModelDidUpdateArticleList(self)
    }
    
    func setSortType(_ sortType: ArticleEntitySortType?) {
        guard self.sortType != sortType else {
            return
        }
        
        self.sortType = sortType
        
        updateAdjustedArticleList()
        delegate?.articleListDataModelDidUpdateArticleList(self)
    }
    
    func isFavouriteArticle(_ article: ArticleEntity) -> Bool {
        // NOTE: status change in progress has no impact
        return RepositoryFactory.repository.isFavouriteArticle(article)
    }
    
    func favouriteStatusOfArticle(_ article: ArticleEntity) -> ArticleFavouriteStatus {
        
        if favouriteStatusChangingArticleList.contains(article) {
            return .favouriteStatusIsChanging
        }
        
        if RepositoryFactory.repository.isFavouriteArticle(article) {
            return .favourite
        }
        
        return .notFavourite
    }
    
    func changeFavouriteStatusForArticle(_ article: ArticleEntity) {
        
        guard originalArticleList.contains(article) else {
            log("WARNING: article \(article) does not belong to list \(originalArticleList)")
            return
        }
        
        guard favouriteStatusChangingArticleList.contains(article) == false else {
            // we are already updating status
            return
        }
        
        let isFavourite = isFavouriteArticle(article)
        
        favouriteStatusChangingArticleList.append(article)
        delegate?.articleListDataModel(self, didUpdateFavouriteStatusForArticle: article)
        
        let changeArticleFavouriteStatusInput = ChangeArticleFavouriteStatusInput(withArticle: article)
        let changeArticleFavouriteStatusOperation = ChangeArticleFavouriteStatusOperation(withInput: changeArticleFavouriteStatusInput)
        changeArticleFavouriteStatusOperation.completionBlock = { [weak self, unowned changeArticleFavouriteStatusOperation] in
            self?.didFinishChangeArticleFavouriteStatusOperation(changeArticleFavouriteStatusOperation, initialArticleState: isFavourite)
        }
        
        operationQueue.addOperation(changeArticleFavouriteStatusOperation)
    }
    
    private func didFinishChangeArticleFavouriteStatusOperation(_ operation: ChangeArticleFavouriteStatusOperation, initialArticleState wasArticleFavourite: Bool) {
        
        dispatch_main_sync_safe {
            
            let operationArticle: ArticleEntity = operation.input().article
            self.favouriteStatusChangingArticleList.remove(object: operationArticle)
            
            if operation.output.isSuccessful {
                if wasArticleFavourite {
                    RepositoryFactory.repository.removeFavouriteArticle(operationArticle)
                } else {
                    RepositoryFactory.repository.addFavouriteArticle(operationArticle)
                }
            } else {
               // operation.output.isSuccessful == false
            }
            
            let correspondingArticleInList: ArticleEntity? = self.articleList.first(where: { (article: ArticleEntity) -> Bool in
                article == operation.input().article
            })
            
            if let articleInList = correspondingArticleInList {
                // data in list has changed
                self.delegate?.articleListDataModel(self, didUpdateFavouriteStatusForArticle: articleInList)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateAdjustedArticleList() {
        
        guard originalArticleList.isEmpty == false else {
            adjustedArticleList = []
            return
        }
        
        var updatedList: [ArticleEntity] = originalArticleList
        
        if searchText.isEmpty == false {
            updatedList = ArticleEntity.articleList(updatedList, filteredBy: searchText)
        }
        
        if let sortType = sortType {
            updatedList = ArticleEntity.articleList(updatedList, sortedBy: sortType)
        }

        adjustedArticleList = updatedList
    }
    
    // MARK: - Notifications
    
    @objc private func didReceiveArticleFavouriteStatusHasChangedNotification(_ notification: Notification) {
        
        guard let article = NotificationManager.sharedManager.articleFromFavouriteStatusHasChangedNotification(notification) else {
            log("WARNING! notification does not contain article \(notification)")
            return
        }
        
        guard articleList.contains(article) else {
            return
        }
        
        delegate?.articleListDataModel(self, didUpdateFavouriteStatusForArticle: article)
    }
}
