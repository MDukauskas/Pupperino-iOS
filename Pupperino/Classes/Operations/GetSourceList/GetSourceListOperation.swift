//
//  GetSourceListOperation.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class GetSourceListOperation: TSMBaseServerOperation {

    // MARK: - Methods
    // MARK: - Overriding TSMBaseOperation
    
    override func createOutput() -> TSMBaseOperationOutput {
        return GetSourceListOutput()
    }
    
    // MARK: - Overriding TSMBaseServerOperation
    
    override func urlMethodName() -> String {
        return "sources"
    }
    
    override func httpMethod() -> String {
        return "GET"
    }
    
    override func additionalUrlParametersDictionary() -> [String: String]? {
        return ["apiKey": Constants.Server.newsApiKey]
    }
    
    override func parseResponseDict(_ responseDict: [String: Any]) {
        
        guard let sourceDictList = responseDict["sources"] as? [[String: Any]] else {
            log("WARNING: could not parse `sources` from response dictionary \(responseDict)")
            return
        }
        
        var sourceList: [SourceEntity] = []
        sourceList.reserveCapacity(sourceDictList.count)
        
        for sourceDict in sourceDictList {
            if let source = SourceEntity(withDictionary: sourceDict) {
                sourceList.append(source)
            } else {
                log("WARNING: could not parse source from source dictionary \(sourceDict)")
            }
        }
        
        output().sourceList = sourceList
        output.isSuccessful = true
    }
    
    // MARK: - Public helpers
    
    func output() -> GetSourceListOutput {
        // swiftlint:disable force_cast
        return output as! GetSourceListOutput
        // swiftlint:enable force_cast
    }
}
