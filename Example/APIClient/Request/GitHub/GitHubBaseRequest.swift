//
//  GitHubBaseRequest.swift
//  NetworkManager
//
//  Created by John Wong on 28/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class GitHubBaseRequest: BaseRequest {
    var domain: String { return "https://api.github.com" }
    public var path: String { return "" }
    public var method: HTTPMethod { return .get }
    public var encoding: APIEncoding { return APIEncoding.http }
}
