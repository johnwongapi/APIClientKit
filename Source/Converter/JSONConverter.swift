//
//  JSONConverter.swift
//  APIClient
//
//  Created by John Wong on 29/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Foundation

public class JSONConverter: BaseConverter {    
    public static func result(from data: Data) -> Any? {
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}
