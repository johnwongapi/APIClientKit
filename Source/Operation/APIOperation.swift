//
//  APIOperation.swift
//  APIClient
//
//  Created by John Wong on 27/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Foundation
import Alamofire

public class ConcurrentOperation: Operation {
    override public var isConcurrent: Bool {
        return true
    }
    
    private var _isExecuting: Bool = false
    override public var isExecuting: Bool {
        get {
            return _isExecuting
        }
        set {
            if _isExecuting != newValue {
                self.willChangeValue(forKey: "isExecuting")
                _isExecuting = newValue
                self.didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    private var _isFinished: Bool = false
    override public var isFinished: Bool {
        get {
            return _isFinished
        }
        set {
            if _isFinished != newValue {
                self.willChangeValue(forKey: "isFinished")
                _isFinished = newValue
                self.didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override public func start() {
        // implementation must not call super at any time.
        guard !self.isCancelled else {
            self.completeOperation()
            return
        }
        self.isExecuting = true
        self.main()
    }
    
    func completeOperation() {
        self.isExecuting = false
        self.isFinished = true
    }
}

public final class APIOperation<T: BaseConverter>: ConcurrentOperation {
    var alamofireRequest: Alamofire.Request?
    
    let request: BaseRequest
    let converter: T.Type?
    let manager: Alamofire.SessionManager
    let completionQueue: DispatchQueue
    var completion: ((APIResult<T.Result>)-> Void)? = nil
    
    init(request: BaseRequest,
         converter: T.Type? = nil,
         manager: Alamofire.SessionManager = APIClient.default.sessionManager) {
        self.request = request
        self.converter = converter
        self.manager = manager
        self.completionQueue = request.callBackQueue
    }
    
    override public func main() {
        guard !self.isCancelled else { return }
        
        var request = manager
            .request(self.request.url,
                     method: self.request.method.toAlamofireMethod(),
                     parameters: self.request.configParameters(),
                     encoding: self.request.encoding.toAlamofireEncoding(),
                     headers: self.request.configHeader())
            .validate()
        
//        if let credential = self.repo.credential {
//            request.authenticate(usingCredential: credential)
//        }
        
        if var urlRequest = request.request {
            urlRequest.timeoutInterval = self.request.timeoutInterval
//            if !self.request.needCaching {
//                urlRequest.cachePolicy = .reloadIgnoringCacheData
//            }
            request = manager.request(urlRequest)
        }
        
        self.alamofireRequest = request
        
        request.responseData(queue: completionQueue) { [weak self] dataResponse in
            guard let strongSelf = self, !strongSelf.isCancelled else { return }
            guard let completion = strongSelf.completion, let converter = strongSelf.converter else {
                strongSelf.completeOperation()
                return
            }
            
            let responseInfo = NetworkResponseInfo(request: dataResponse.request,
                                                   urlResponse: dataResponse.response,
                                                   responseData: dataResponse.data,
                                                   error: dataResponse.error)
            
            if let error = dataResponse.error {
                if let statusCode = dataResponse.response?.statusCode {
                    completion(.error(.backendError(statusCode: statusCode), responseInfo))
                } else {
                    completion(.error(.connectionError(errorCode: (error as NSError).code, message: error.localizedDescription), responseInfo))
                }
            } else {
                if let data = dataResponse.data, let result = converter.result(from: data) {
                    completion(.success(result, responseInfo))
                } else {
                    completion(.error(.dataConverterFail(data: dataResponse.data), responseInfo))
                }
            }
        }
        
        request.resume()
    }
    
    override public func cancel() {
        self.alamofireRequest?.cancel()
        super.cancel()
        self.completeOperation()
        self.alamofireRequest = nil
    }
    
    func setCompletionBlock(_ block: ((APIResult<T.Result>)-> Void)?) {
        self.completion = block
    }
}

