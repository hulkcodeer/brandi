//
//  ApiError.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import Foundation
import RxSwift

internal enum ApiError {
    case responseError(error: Enums.NetworkError)
    case otherServerError(data: Data)
    
    class Enums {}
}

extension ApiError: LocalizedError {
    internal var errorDescription: String? {
        switch self {
        case .responseError(let type): return type.errorDescription
        case .otherServerError(let data): return data.description
        }
    }
}

// MARK: - Network Errors

extension ApiError.Enums {
    enum NetworkError {
        case timeout(url: String, errorCode: Int)
        case parsing(url: String, statusCode: Int)
        case other(errorDesc: String, url: String, statusCode: Int, errorCode: Int)
        case notConnected(url: String, errorCode: Int)
        case cancelled(url: String, errorCode: Int)
        case unknown(url: String)
    }
}

extension ApiError.Enums.NetworkError: LocalizedError {
    internal var errorDescription: String? {
        switch self {
        case .timeout: return "Request timeout."
        case .parsing: return "Parsing error."
        case .other(let errorDesc, _, _, _): return "\(errorDesc)"
        case .notConnected: return "Device not connected."
        case .cancelled: return "Cancelled."
        case .unknown: return "Unknown error occurred."
        }
    }
    
    internal var errorCode: Int? {
        switch self {
        case .timeout(_, let code): return code
        case .parsing: return 901
        case .other(_, _, _, let code): return code
        case .notConnected(_, let code): return code
        case .cancelled(_, let code): return code
        case .unknown: return 802
        }
    }
}
