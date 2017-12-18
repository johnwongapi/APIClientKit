//
//  API.swift
//  APIClient
//
//  Created by John Wong on 27/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Foundation
import Alamofire

// cancel single request in group

public class APIClient {
    
}

extension APIClient {
    public class `default` {
        public static let callbackQueue: DispatchQueue = DispatchQueue(label: "com.apiclientkit.callbackqueue", attributes: .concurrent)
        public static let operationQueue: OperationQueue = OperationQueue()
        public static let sessionManager: Alamofire.SessionManager = {
            let manager = SessionManager(configuration: URLSessionConfiguration.default)
            manager.startRequestsImmediately = false
            return manager
        }()
    }
}

extension APIClient {
    @discardableResult
    public static func sendAsync<T: BaseConverter>(request: BaseRequest,
                                                   converter: T.Type,
                                                   manager: Alamofire.SessionManager = APIClient.default.sessionManager,
                                                   operationQueue: OperationQueue = APIClient.default.operationQueue,
                                                   completionQueue: DispatchQueue = .main,
                                                   completion: (((APIResult<T.Result>)) -> Void)?) -> APIOperationGroup {
        let group = APIOperationGroup(operationQueue: operationQueue, completionQueue: completionQueue)
        let operation = APIOperation(request: request, converter: converter, manager: manager)
        group.addOperation(operation)
        group.setCompletionBlock {
            let result = group.getResult(type: converter.Result.self, index: 0)
            completion?(result)
        }
        group.start()
        return group
    }
    
    public static func sendAsync<T: BaseConverter,
                                S: BaseConverter>(request1: BaseRequest,
                                                  converter1: T.Type,
                                                  request2: BaseRequest,
                                                  converter2: S.Type,
                                                  manager: Alamofire.SessionManager = APIClient.default.sessionManager,
                                                  operationQueue: OperationQueue = APIClient.default.operationQueue,
                                                  completionQueue: DispatchQueue = .main,
                                                  completion: @escaping ((_ reulst1: APIResult<T.Result>, _ result2: APIResult<S.Result>) -> Void)) -> APIOperationGroup {
        let group = APIOperationGroup(operationQueue: operationQueue, completionQueue: completionQueue)
        let operation1 = APIOperation(request: request1, converter: converter1, manager: manager)
        let operation2 = APIOperation(request: request1, converter: converter1, manager: manager)
        group.addOperation(operation1)
        group.addOperation(operation2)
        group.setCompletionBlock {
            let result1 = group.getResult(type: converter1.Result.self, index: 0)
            let result2 = group.getResult(type: converter2.Result.self, index: 1)
            completion(result1, result2)
        }
        group.start()
        return group
    }
}
