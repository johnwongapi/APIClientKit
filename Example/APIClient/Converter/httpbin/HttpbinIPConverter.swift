//
//  HttpbinIPConverter.swift
//  NetworkManager
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import APIClientKit

class HttpbinIPConverter: BaseConverter {
    static func result(from data: Data) -> HttpbinIP? {
        guard let json = JSONConverter.result(from: data) as? [String: Any] else { return nil }
        return HttpbinIP(origin: json["origin"] as? String ?? "")
    }
}
