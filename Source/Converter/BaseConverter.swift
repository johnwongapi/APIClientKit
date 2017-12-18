//
//  BaseConverter.swift
//  APIClient
//
//  Created by John Wong on 28/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

import Foundation

public protocol BaseConverter: class {
    associatedtype Result
    static func result(from: Data) -> Result?
}
