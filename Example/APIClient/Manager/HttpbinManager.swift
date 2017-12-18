//
//  HttpbinManager.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class HttpbinManager {
    static let shared = HttpbinManager()
    private init() {}
}


extension HttpbinManager {
    func getIPAddress(completion: @escaping (APIResult<HttpbinIP>) -> Void) {
        APIClient.sendAsync(request: HttpbinIPRequest(), converter: HttpbinIPConverter.self) {
            (result) in
            completion(result)
        }
    }
}

extension HttpbinManager {
    func post(something data: Any, completion: @escaping (APIResult<HttpbinPostResult>) -> Void) {
        let request = HttpbinPostRequest(data: data)
        APIClient.sendAsync(request: request, converter: HttpbinPostConverter.self) {
            (result) in
            completion(result)
        }
    }
}
