//
//  HTTPMethod.swift
//  APIClient
//
//  Created by John Wong on 27/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Alamofire

public enum HTTPMethod {
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
    case trace
    case connect
}

extension HTTPMethod {
    func toAlamofireMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .options:  return .options
        case .get:      return .get
        case .head:     return .head
        case .post:     return .post
        case .put:      return .put
        case .patch:    return .patch
        case .delete:   return .delete
        case .trace:    return .trace
        case .connect:  return .connect
        }
    }
}
