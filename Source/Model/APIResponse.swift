//
//  APIResponse.swift
//  APIClient
//
//  Created by John Wong on 27/11/2017.
//  Copyright © 2017 John Wong. All rights reserved.
//

public enum APIResult<ResponseType> {
    case success(ResponseType?, NetworkResponseInfo)
    case error(APIError, NetworkResponseInfo)
}

public enum APIError: Error {
    case backendError(statusCode: Int)
    case connectionError(errorCode: Int, message: String)
    case dataConverterFail(data: Data?)
    case unknown
}

public struct NetworkResponseInfo {
    public let request: URLRequest?
    public let urlResponse: HTTPURLResponse?
    public let responseData: Data?
    public let error: Error?
    
    static let `nil` = NetworkResponseInfo(request: nil, urlResponse: nil, responseData: nil, error: nil)
}
