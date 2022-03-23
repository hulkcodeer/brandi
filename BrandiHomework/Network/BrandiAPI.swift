//
//  BrandiAPI.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import Foundation
import RxSwift

protocol BrandiAPI: AnyObject {
    func fetchList(by model: SearchFilterModel) -> Single<Data>
}

internal final class RestApi: BrandiAPI {
 
    init() {}
        
    func fetchList(by model: SearchFilterModel) -> Single<Data> {
        let url = "https://dapi.kakao.com/v2/search/image?query=\(model.query.urlEncoded)&sort=\(model.sort.rawValue)&page=\(model.page)&size=\(model.size)"
        return NetworkWorker.rx.rxRequest((url: url, method: .get, parameters: nil, headers: ["Authorization":"KakaoAK e54ff09acc92305f506e5668a0f6db5a"]))
    }
}
