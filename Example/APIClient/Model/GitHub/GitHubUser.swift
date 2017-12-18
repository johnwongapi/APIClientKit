//
//  GitHubUser.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Foundation

class GitHubUser {
    var loginName: String
    var id: Int
    var avatarURL: URL?
    var isAdmin: Bool
    var score: Float
    
    init(loginName: String,
         id: Int,
         avatarURL: String,
         isAdmin: Bool,
         score: Float) {
        self.loginName = loginName
        self.id = id
        self.avatarURL = URL(string: avatarURL)
        self.isAdmin = isAdmin
        self.score = score
    }
}
