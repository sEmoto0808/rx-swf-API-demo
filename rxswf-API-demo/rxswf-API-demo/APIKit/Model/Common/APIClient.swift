//
//  APIClient.swift
//  rxswf-API-demo
//
//  Created by S.Emoto on 2018/09/30.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import APIKit
import UIKit

final class APIClient {
    
    func rx_get<T: Request>(withRequest request: T, from UI: Observable<Any>) -> Driver<T.Response> {
        return UI
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ _ in
                return self.get(withRequest: request)
            })
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}

extension APIClient {
    
    func get<T: Request>(withRequest request: T) -> Observable<T.Response> {
        
        return Observable
            .create { observer in
                let task = Session.send(request) { result in
                    switch result {
                    case .success(let res):
                        observer.on(.next(res))
                        observer.on(.completed)
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
                return Disposables.create {
                    task?.cancel()
                }
        }
    }
}
