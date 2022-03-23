//
//  NetworkWorker.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: NetworkWorker {
    typealias RequestData = (url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, headers: [String: String]?)
    
    internal static func rxRequest(_ requestData: RequestData) -> Single<Data> {
        Single.create { single in
            Base.shared.request(requestData.url, method: requestData.method, parameters: requestData.parameters, headers: requestData.headers, result: { result in
                switch result {
                case .success(let data):
                    single(.success(data))
                    
                case .failure(let error):
                    single(.error(error))
                }
            })
            
            return Disposables.create {}
        }
        .observeOn(MainScheduler.instance)
    }
}

extension NetworkWorker {
    internal func request(_ url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, result: @escaping (Result<Data, ApiError>) -> Void) {
        let encode: ParameterEncoding = URLEncoding.default
        let _headers: HTTPHeaders = .init(headers ?? [:])
        let manager = self.manager
        manager.request(url, method: method, parameters: parameters, encoding: encode, headers: _headers)
            .validate(contentType: ["text/html", "text/plain", "application/json"])
            .response { responseObject in
                let statusCode = responseObject.response?.statusCode ?? 0
                guard let data = responseObject.data else {
                    return
                }
                                
                var strResponse: String?
            
                if let str = String(data: data, encoding: .nonLossyASCII) {
                    strResponse = str
                }
                let debugDesc = """
                <URL: \(method.rawValue)> \(url)
                parameter: \(parameters ?? [:])
                code: \(statusCode)
                ========== Response DATA ==========
                
                \(strResponse ?? responseObject.response.debugDescription)
                
                ========== Response END ==========
                Data length: \(responseObject.data?.count ?? 0)
                """
                
                printLog(out: debugDesc)
                                                
                switch statusCode {
                case 200 :
                    result(.success(data))
                    
                default:
                    if let error = responseObject.error,
                       let underlyingError = error.underlyingError,
                       let urlError = underlyingError as? URLError {
                        result(.failure(.responseError(error: ApiError.Enums.NetworkError.other(errorDesc: error.errorDescription ?? "", url: url, statusCode: statusCode, errorCode: urlError.code.rawValue))))
                    } else {
                        printLog(out:"Unknown error occurred.")
                        result(.failure(.responseError(error: ApiError.Enums.NetworkError.unknown(url: url))))
                    }
                }
            }
    }
}

internal final class NetworkWorker: NSObject {
    internal static let shared = NetworkWorker()
    
    // init API 호출시만 사용하는 Session
    internal let initManager: Session = {
        Alamofire.Session.default
    }()
    
    // http 통신 타임아웃 설정 (모든 API에 사용되는 Session)
    internal lazy var manager: Session = {
        let configuration: URLSessionConfiguration = .default
        let timeOutDouble: Double = 3000
        configuration.timeoutIntervalForRequest = timeOutDouble
        configuration.timeoutIntervalForResource = timeOutDouble
        let sessionManager: Session = .init(configuration: configuration, startRequestsImmediately: true)
        return sessionManager
    }()
    
    override private init() {}
    
    deinit {
        printLog(out: "\(type(of: self)): Deinited")
    }
}
