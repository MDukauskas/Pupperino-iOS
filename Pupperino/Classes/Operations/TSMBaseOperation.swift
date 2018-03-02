//
//  TSMBaseOperation.swift
//
//  A Generic operation class which is ready to be used by overriding.
//  Is dependent on: `TSMBaseOperationOutput`
//
//
//  Child class should override:
//  * `createOutput()` - when custom output is used
//  * `startOperation()` - always
//
//  Other:
//  * when actions implemented by `startOperation()` are finished must always call `finishOperation()`
//

import Foundation

class TSMBaseOperation: Operation {
    
    // MARK: - Declarations
    private(set) var input: Any?
    private(set) var output: TSMBaseOperationOutput!
    
    private var _executing: Bool = false
    private var _finished: Bool = false
    
    // MARK: - Methods -
    init(withInput input: Any? = nil) {
        super.init()
        
        self.input = input
        self.output = createOutput()
        self.output.input = self.input
    }
    
    // MARK: - Overriding Operation
    override func cancel() {
        // Overriding class, should call super AFTER implementing it's own actions. E.g.:
        //
        // override func cancel() {
        //     <specific actions>
        //     super.cancel()
        // }

        guard isCancelled == false else {
            return
        }
        
        super.cancel()
        completionBlock = nil
        
        if isExecuting {
            finishOperation()
        }
    }
    
    override func start() {
        
        isExecuting = true
        isFinished = false
        
        if isCancelled {
            finishOperation()
            return
        }
        
        startOperation()
    }
    
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override class func automaticallyNotifiesObservers(forKey key: String) -> Bool {
        return true
    }
    
    // MARK: - Methods for overriding
    func createOutput() -> TSMBaseOperationOutput {
        // Overriding class should provide custom output.
        // NOTE: output.input value will be assigned automatically by `TSMBaseOperation`
        return TSMBaseOperationOutput()
    }
    
    func startOperation() {
        // Overriding class MUST override this method implementing actions by this operation.
        // NOTES:
        // * After finishing actions always call `finishOperation()`
        // * Do not call `super.startOperation()` when overriding this method
        
        finishOperation()
    }
    
    // MARK: - Operation control
    func finishOperation() {
        // Is not expected to be called externally.
        // Instead, it must be called by child class, when operation must be finished.
        //
        
        if isFinished {
            return
        }
        
        if isExecuting == false {
            return
        }
        
        isFinished = true
        isExecuting = false
    }
}
