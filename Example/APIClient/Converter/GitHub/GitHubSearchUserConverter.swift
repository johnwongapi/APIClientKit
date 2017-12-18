//
//  GitHubSearchUserConverter.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class GitHubSearchUserConverter: BaseConverter {
    static func result(from data: Data) -> GitHubSearchUserResult? {
        guard let json = JSONConverter.result(from: data) as? [String: Any] else { return nil }
        guard let userArray = json["items"] as? [Any] else { return nil }
        let totalCount = json["total_count"] as? Int ?? 0
        var users: [GitHubUser] = []
        for user in userArray {
            guard let userJson = user as? [String: Any] else { return nil }
            let loginName = userJson["login"] as? String ?? ""
            let id = userJson["id"] as? Int ?? 0
            let avatarUrl = userJson["avatar_url"] as? String ?? ""
            let isAdmin = userJson["site_admin"] as? Bool ?? false
            let score = userJson["score"] as? Float ?? 0.0
            let user = GitHubUser(loginName: loginName, id: id, avatarURL: avatarUrl, isAdmin: isAdmin, score: score)
            users.append(user)
        }
        let searchResult = GitHubSearchUserResult(totalCount: totalCount, users: users)
        
        return searchResult
    }
}
