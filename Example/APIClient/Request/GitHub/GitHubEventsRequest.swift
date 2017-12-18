//
//  GitHubEventsRequest.swift
//  NetworkManager
//
//  Created by John Wong on 28/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class GitHubEventsRequest: GitHubBaseRequest {
    override var method: HTTPMethod { return .get }
    override var path: String { return "/events" }
}
