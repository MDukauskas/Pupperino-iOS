//
//  ChangeArticleFavouriteStatusOperation.swift
//  MVC SampleProject
//
//  Created by Admin on 26/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

class ChangeArticleFavouriteStatusOperation: TSMBaseOperation {
    
    // MARK: - Constants
    private let kOperationDurationTimeInterval: TimeInterval = 1.0
    // NOTE: zero is part of value, e.g. 1 means 2 numbers: 0 + 1
    private let kOperationSuccessRandomMaxValue: UInt32 = 2
    private let kOperationFailureMaxValue: UInt32 = 0 // if this value is same or above kOperationSuccessRandomMaxValue, operation will always fail

    // MARK: - Overriding TSMBaseOperation
    
    override func startOperation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + kOperationDurationTimeInterval) {
            self.doActionAndFinishOperation()
        }
    }
    
    // MARK: - Helpers
    
    private func doActionAndFinishOperation() {
        guard isCancelled == false else {
            return
        }
        
        output.isSuccessful = randomizeOperationSuccess()
        finishOperation()
    }
    
    private func randomizeOperationSuccess() -> Bool {
        
        if GenericTools.randomNumberWithMaxValue(kOperationSuccessRandomMaxValue) <= kOperationFailureMaxValue {
            return false
        }
        return true
    }
    
    // MARK: - Public helpers
    
    func input() -> ChangeArticleFavouriteStatusInput {
        // swiftlint:disable force_cast
        return input as! ChangeArticleFavouriteStatusInput
        // swiftlint:enable force_cast
    }
}
