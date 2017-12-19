//
//  APIOperationGroup.swift
//  APIClient
//
//  Created by John Wong on 27/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Foundation
import Alamofire

private class Task {
    var operation: ConcurrentOperation
    var result: Any?
    init(_ operation: ConcurrentOperation) {
        self.operation = operation
    }
}

public final class APIOperationGroup {
//    private let refCode: String = UUID().uuidString
    
    private var tasks: [Task] = []
    private var isStarted: Bool = false
    private lazy var results: [Any?]? = self.tasks.map{$0.result}
    
    private weak var operationQueue: OperationQueue?
    private var onEndOperation: BlockOperation?
    
    private weak var completionQueue: DispatchQueue?
    private var completionBlock: (() -> Void)?
    
    private let accessQueue: DispatchQueue = DispatchQueue(label: "com.apiclientkit.accessqueue", attributes: .concurrent)

    public init(operationQueue: OperationQueue, completionQueue: DispatchQueue?) {
        self.operationQueue = operationQueue
        self.completionQueue = completionQueue
    }
    
    deinit {
        self.clear()
    }
    
    private func clear(){
        self.onEndOperation = nil
        self.tasks.removeAll()
    }

//    func addOperation<T: BaseConverter>(request: BaseRequest,
//                                        converter: T.Type?,
//                                        manager: Alamofire.SessionManager,
//                                        completionQueue: DispatchQueue) {
//        if self.isStarted { return }
//        self.accessQueue.async(flags: .barrier) {
//            let operation = APIOperation<T>(request: request,
//                                            converter: converter,
//                                            manager: manager,
//                                            completionQueue: completionQueue)
//            let task = Task(operation)
//            operation.setCompletionBlock{ [weak self] (result) in
//                guard let `self` = self else { return }
//                self.accessQueue.async(flags: .barrier) {
//                    task.result = result
//                    operation.completeOperation()
//                }
//            }
//            self.tasks.append(Task(operation))
//        }
//    }
    
    func addOperation<T>(_ operation: APIOperation<T>) {
        if self.isStarted { return }
        self.accessQueue.async(flags: .barrier) {
            let task = Task(operation)
            operation.setCompletionBlock{ [weak self] (result) in
                guard let strongSelf = self else { return }
                strongSelf.accessQueue.async(flags: .barrier) {
                    task.result = result
                    operation.completeOperation()
                }
            }
            self.tasks.append(task)
        }
    }
    
    func getResult<T>(index: Int, castAs type: T.Type) -> APIResult<T> {
        guard
            let results = self.results,
            results.count == self.tasks.count,
            results.count > index,
            let result = results[index] as? APIResult<T>
        else {
            return .error(.unknown, .nil)
        }
        
        return result
    }

}

extension APIOperationGroup {
    func setCompletionBlock(_ block: @escaping (() -> Void)) {
        self.completionBlock = block
    }
    
    public func cancel() {
        self.accessQueue.sync() {
            for task in self.tasks {
                task.operation.cancel()
            }
            self.onEndOperation?.cancel()
            self.clear()
        }
    }

    func start() {
        guard !self.isStarted else { return }
        self.isStarted = true
        self.accessQueue.async(flags: .barrier) {

            let onEndOperation = BlockOperation { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.accessQueue.async(flags: .barrier) {
                    if let op = strongSelf.onEndOperation, !op.isCancelled {
                        strongSelf.completionQueue?.async {
                            strongSelf.completionBlock?()
                        }
                    }
                }
            }
            
            for operation in self.tasks.map({$0.operation}) {
                onEndOperation.addDependency(operation)
                self.operationQueue?.addOperation(operation)
            }
            
            self.operationQueue?.addOperation(onEndOperation)
            self.onEndOperation = onEndOperation
        }
    }
}

//extension Task: Equatable {
//    static func ==(lhs: Task, rhs: Task) -> Bool {
//        return lhs.operation == rhs.operation
//    }
//}
//
//extension APIOperationGroup: Equatable {
//    public static func ==(lhs: APIOperationGroup, rhs: APIOperationGroup) -> Bool {
//        return lhs.refCode == rhs.refCode
//    }
//}
//
//private extension Array where Element: Equatable {
//    mutating func remove(object: Element) {
//        if let index = index(of: object) {
//            remove(at: index)
//        }
//    }
//}

