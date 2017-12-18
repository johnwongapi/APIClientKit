//
//  APIEncoding.swift
//  APIClient
//
//  Created by John Wong on 27/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Alamofire

public enum APIEncoding {
    case http
    case json
    case plist
}

extension APIEncoding {
    func toAlamofireEncoding() -> Alamofire.ParameterEncoding {
        switch self {
        case .http:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        case .plist:
            return PropertyListEncoding.default
        }
    }
}
