//
//  HttpbinBaseRequest.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class HttpbinBaseRequest: BaseRequest {
    var domain: String { return "https://httpbin.org" }
    public var path: String { return "" }
    public var method: HTTPMethod { return .get }
    public var encoding: APIEncoding { return APIEncoding.http }
}
