//
//  ArticleDetailsDataModel.swift
//  MVC SampleProject
//
//  Created by Admin on 15/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

protocol ArticleDetailsDataModelDelegate: class {
    func articleDetailsDataModelDidUpdateArticleFavouriteStatus(_ dataModel: ArticleDetailsDataModel)
}

class ArticleDetailsDataModel {
    // MARK: - Declarations
    private(set) var article: ArticleEntity
    private(set) weak var delegate: ArticleDetailsDataModelDelegate?
    
    private(set) var isFavouriteStatusChangeInProgress: Bool = false
    private var operationQueue = OperationQueue()
    
    // MARK: - Methods -
    init(withArticle article: ArticleEntity, delegate: ArticleDetailsDataModelDelegate?) {
        self.article = article
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
    
    func articleFavouriteStatus() -> ArticleFavouriteStatus {
        
        if isFavouriteStatusChangeInProgress {
            return .favouriteStatusIsChanging
        }
        
        if RepositoryFactory.repository.isFavouriteArticle(article) {
            return .favourite
        }
        
        return .notFavourite
    }
    
    func changeArticleFavouriteStatus() {
        
        guard isFavouriteStatusChangeInProgress == false else {
            return
        }
        
        let isFavourite = RepositoryFactory.repository.isFavouriteArticle(article)
        
        isFavouriteStatusChangeInProgress = true
        delegate?.articleDetailsDataModelDidUpdateArticleFavouriteStatus(self)
        
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
            self.isFavouriteStatusChangeInProgress = false
            
            if operation.output.isSuccessful {
                if wasArticleFavourite {
                    RepositoryFactory.repository.removeFavouriteArticle(operationArticle)
                } else {
                    RepositoryFactory.repository.addFavouriteArticle(operationArticle)
                }
            } else {
                // operation.output.isSuccessful == false
            }
            
            self.delegate?.articleDetailsDataModelDidUpdateArticleFavouriteStatus(self)
        }
    }
    
    // MARK: - Notifications
    
    @objc private func didReceiveArticleFavouriteStatusHasChangedNotification(_ notification: Notification) {
        
        guard let article = NotificationManager.sharedManager.articleFromFavouriteStatusHasChangedNotification(notification) else {
            log("WARNING! notification does not contain article \(notification)")
            return
        }
        
        guard article == self.article else {
            return
        }
        
        delegate?.articleDetailsDataModelDidUpdateArticleFavouriteStatus(self)
    }
}
