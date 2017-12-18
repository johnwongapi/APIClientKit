//
//  HttpbinPostRequest.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class HttpbinPostRequest: HttpbinBaseRequest {
    override var method: HTTPMethod { return .post }
    override var path: String { return "/post" }
    override var encoding: APIEncoding { return .json }
    var parameters: [String : Any] {
        return ["data": data]
    }
    
    let data: Any
    init(data: Any) {
        self.data = data
    }
}
