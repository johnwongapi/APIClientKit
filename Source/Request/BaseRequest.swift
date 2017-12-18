//
//  BaseRequest.swift
//  APIClient
//
//  Created by John Wong on 27/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//
import Foundation

public protocol BaseRequest: class {
    var domain: String { get }
    var path: String { get }
    var url: String { get }
    
    var method: HTTPMethod { get }
    var encoding: APIEncoding { get }
    
    var header: [String:String] { get }
    func configHeader() -> [String:String]
    
    var parameters: [String: Any] { get }
    func configParameters() -> [String: Any]
    
    var callBackQueue: DispatchQueue { get }
    
    var timeoutInterval: TimeInterval { get }
}

public extension BaseRequest {
    var url: String {
        if self.path.isEmpty {
            return self.domain
        }
        
        var domain = self.domain
        var path = self.path
        if domain.last == "/" {
            domain.removeLast()
        }
        if path.first == "/" {
            path.removeFirst()
        }
        
        return "\(domain)/\(path)"
    }
    
    var header: [String:String] {
        return [:]
    }
    
    func configHeader() -> [String: String] {
        return self.header
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    func configParameters() -> [String: Any] {
        return self.parameters
    }
    
    var callBackQueue: DispatchQueue {
        return APIClient.default.callbackQueue
    }

    var timeoutInterval: TimeInterval {
        return 30
    }
}
