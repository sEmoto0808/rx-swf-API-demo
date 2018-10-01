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
    
    struct Input {
        // 監視対象（トリガー）
        var repositoryName: Observable<String>
    }
    
    struct Output {
        var rx_repositories: Driver<[RepositoryInfo]>
    }
    
    // MARK: - Properties
    
    // Viewから受け取るトリガー
    private var _input: RepositoryViewModel.Input!
    // Viewにデータをバインドする
    private var _output: RepositoryViewModel.Output!
    private let repositoryModel = RepositoryModel()
    
    // 初期化
    init(trigger: RepositoryViewModel.Input) {
        _input = trigger
        _output = RepositoryViewModel.Output.init(rx_repositories: fetchUserInfo())
    }
    
    func output() -> RepositoryViewModel.Output {
        return _output
    }
}

extension RepositoryViewModel {
    
    // GitHubAPIから取得したデータをDriverに変換する
    private func fetchUserInfo() -> Driver<[RepositoryInfo]> {
        
        return _input.repositoryName
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
                return RepositoryModel().get(request: GitHubAPI.SearchRepositories(userName: text))
            })
            // 3.Driverに変換
            .observeOn(MainScheduler.instance)  // 以降メインスレッドで実行
            .do(onNext: { response in
                //ネットワークインジケータを非表示状態にする
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: []) //Driverに変換する
    }
}
