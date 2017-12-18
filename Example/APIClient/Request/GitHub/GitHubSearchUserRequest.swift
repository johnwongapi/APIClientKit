//
//  GitHubSearchUserRequest.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class GitHubSearchUserRequest: GitHubBaseRequest {
    override var method: HTTPMethod { return .get }
    override var path: String { return "search/users" }
    var parameters: [String : Any] {
        return ["q": self.searchField]
    }
    
    var searchField: String
    
    init(searchField: String) {
        self.searchField = searchField
    }
}
