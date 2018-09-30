//
//  UserInfoViewModel.swift
//  rxswf-API-demo
//
//  Created by S.Emoto on 2018/09/30.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper


final class RepositoryViewModel {
    
    // MARK: - Properties
    
    // オブジェクトの初期化時にプロパティの初期値を設定する
    lazy var rx_repositories: Driver<[RepositoryInfo]> = fetchUserInfo()
    // 監視対象
    var repositoryName: Observable<String>!
    
    // 初期化
    // 監視対象のセット
    init(nameObservable: Observable<String>) {
        repositoryName = nameObservable
    }
}

extension RepositoryViewModel {
    
    // GitHubAPIから取得したデータをDriverに変換する
    private func fetchUserInfo() -> Driver<[RepositoryInfo]> {
        
        return repositoryName
            // 1.処理中にインジケータを表示する
            .subscribeOn(MainScheduler.instance) // 以降メインスレッドで実行
            .do(onNext: { response in
                //ネットワークインジケータを表示状態にする
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            // 2.GitHubAPIにアクセスする（APIKit）
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))  // 以降バックグラウンドで実行
            .flatMapLatest({ text in
                
                //APIからデータを取得する
                return APIClient().get(withRequest: GitHubAPI.SearchRepositories(userName: text))
            })
            // 3.Driverに変換
            .observeOn(MainScheduler.instance)  // 以降メインスレッドで実行
            .do(onNext: {response in
                //ネットワークインジケータを非表示状態にする
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: []) //Driverに変換する
    }
}
