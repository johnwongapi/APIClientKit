//
//  GitHubManager.swift
//  NetworkManager
//
//  Created by John Wong on 28/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class GitHubManager {
    static let shared = GitHubManager()
    private init() {}
}

extension GitHubManager {
    func getEvents(completion: @escaping (APIResult<[GitHubEvent]>) -> Void) {
        APIClient.sendAsync(request: GitHubEventsRequest(), converter: GitHubEventsConverter.self) { (result) in
            completion(result)
        }
    }
}

extension GitHubManager {
    func searchUser(searchField: String, completion: @escaping (APIResult<GitHubSearchUserResult>) -> Void) {
        let request = GitHubSearchUserRequest(searchField: searchField)
        APIClient.sendAsync(request: request, converter: GitHubSearchUserConverter.self) { (result) in
            completion(result)
        }
    }
}
