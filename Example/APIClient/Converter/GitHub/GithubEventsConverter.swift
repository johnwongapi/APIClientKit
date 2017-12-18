//
//  GithubEventsConverter.swift
//  NetworkManager
//
//  Created by John Wong on 28/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class GitHubEventsConverter: BaseConverter {
    static func result(from data: Data) -> [GitHubEvent]? {
        guard let jsonArray = JSONConverter.result(from: data) as? [Any] else { return nil }
        return jsonArray.map { json in
            let event = GitHubEvent()
            // TODO:
            event.name = "name"
            return event
        }
    }
}
