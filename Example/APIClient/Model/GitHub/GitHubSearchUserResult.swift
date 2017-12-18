//
//  GitHubSearchUserResult.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Foundation

class GitHubSearchUserResult {
    let totalCount: Int
    let users: [GitHubUser]
    
    init(totalCount: Int, users: [GitHubUser]) {
        self.totalCount = totalCount
        self.users = users
    }
}
