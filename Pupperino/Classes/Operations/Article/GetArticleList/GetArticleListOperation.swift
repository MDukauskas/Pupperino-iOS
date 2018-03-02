//
//  GetArticleListOperation.swift
//  MVC SampleProject
//
//  Created by Admin on 13/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class GetArticleListOperation: TSMBaseServerOperation {

    // MARK: - Methods
    // MARK: - Overriding TSMBaseOperation
    
    override func createOutput() -> TSMBaseOperationOutput {
        return GetArticleListOutput()
    }
    
    // MARK: - Overriding TSMBaseServerOperation
    
    override func urlMethodName() -> String {
        return "everything"
    }
    
    override func httpMethod() -> String {
        return "GET"
    }
    
    override func additionalUrlParametersDictionary() -> [String: String]? {
        
        var parametersDict: [String: String] = [:]
        parametersDict["apiKey"] = Constants.Server.newsApiKey
        
        // Optional params
        if let input = input as? GetArticleListInput,
            let source = input.source {
            parametersDict["sources"] = source.id
        }
        
        return parametersDict
    }
    
    override func parseResponseDict(_ responseDict: [String: Any]) {
        
        guard let articlesDictList = responseDict["articles"] as? [[String: Any]] else {
            log("WARNING: could not parse `articles` from response dictionary \(responseDict)")
            return
        }
        
        var articleList: [ArticleEntity] = []
        articleList.reserveCapacity(articlesDictList.count)
        
        for articleDict in articlesDictList {
            if let article = ArticleEntity(withDictionary: articleDict) {
                articleList.append(article)
            } else {
                log("WARNING: could not parse source from source dictionary \(articleDict)")
            }
        }
        
        output().articleList = articleList
        output.isSuccessful = true
    }
    
    // MARK: - Public helpers
    
    func output() -> GetArticleListOutput {
        // swiftlint:disable force_cast
        return output as! GetArticleListOutput
        // swiftlint:enable force_cast
    }
}
