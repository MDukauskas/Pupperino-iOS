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
        return nil
    }
    
    override func parseResponseDictionary(_ responseDictionary: [String : Any]) {
        return
    }
    
    // MARK: - Public helpers
    func output() -> GetSourceListOutput {
        // swiftlint:disable force_cast
        return output as! GetSourceListOutput
        // swiftlint:enable force_cast
    }
}
