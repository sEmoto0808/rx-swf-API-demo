//
//  RepositoryModel.swift
//  rxswf-API-demo
//
//  Created by S.Emoto on 2018/10/01.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RepositoryModel {
    
    func rx_get(from UI: Observable<String>) -> Driver<[RepositoryInfo]> {
        return UI
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ text in
                // APIからデータを取得する
                return APIClient().send(withRequest: GitHubAPI.SearchRepositories(userName: text))
                    .asDriver(onErrorJustReturn: []) // 0件だった場合のonError対策
            })
            .observeOn(MainScheduler.instance)
            .do(onNext: { response in
                // Success
                print("success")
            })
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
