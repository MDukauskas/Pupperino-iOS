//
//  SourceListDataModel.swift
//  MVC SampleProject
//
//  Created by Admin on 12/02/2018.
//  Copyright © 2018 Telesoftas. All rights reserved.
//

import UIKit

protocol SourceListDataModelDelegate: class {
    // data loading
    func sourceListDataModelStartedDataLoading(_ dataModel: SourceListDataModel)
    func sourceListDataModelFinishedDataLoading(_ dataModel: SourceListDataModel)
    func sourceListDataModelFailedDataLoading(_ dataModel: SourceListDataModel)
}

class SourceListDataModel {

    // MARK: - Declarations
    private(set) var sourceList: [SourceEntity] = []
    private weak var delegate: SourceListDataModelDelegate?
    
    private var operationQueue = OperationQueue()
    private var isDataLoadInProgress = false
    
    // MARK: - Methods -
    init(withDelegate delegate: SourceListDataModelDelegate?) {
        self.delegate = delegate
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
        delegate?.sourceListDataModelStartedDataLoading(self)
        
        let getSourceListOperation = GetSourceListOperation()
        getSourceListOperation.completionBlock = { [weak self, unowned getSourceListOperation] in
            self?.didFinishGetSourceListOperation(getSourceListOperation)
        }
        
        operationQueue.addOperation(getSourceListOperation)
    }
    
    private func didFinishGetSourceListOperation(_ operation: GetSourceListOperation) {
        
        dispatch_main_sync_safe {
            self.isDataLoadInProgress = false
            
            if operation.output.isSuccessful {
                self.sourceList = operation.output().sourceList
                
                self.delegate?.sourceListDataModelFinishedDataLoading(self)
            } else {
                // operation.output.isSuccessful == false
                self.delegate?.sourceListDataModelFailedDataLoading(self)
            }
        }
    }
    
    func sourceAtIndex(_ index: Int) -> SourceEntity? {
        
        guard index < sourceList.count, index >= 0 else {
            log("WARNING! unexpected index \(index), while list size is \(sourceList.count)")
            return nil
        }
        
        return sourceList[index]
    }
}
