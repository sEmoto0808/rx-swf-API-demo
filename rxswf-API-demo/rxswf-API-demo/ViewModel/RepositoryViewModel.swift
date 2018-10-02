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
        var repositoryName: Observable<Void>
    }
    
    struct Output {
        var rx_repositories: Driver<[RepositoryInfo]>
    }
    
    // MARK: - Properties
    
    // Viewから受け取るトリガー
    private var _input: RepositoryViewModel.Input!
    // Viewにデータをバインドする
    private var _output: RepositoryViewModel.Output!
    // GitHub APIからデータを取得するModel
    private let repositoryModel = RepositoryModel()
    
    // 初期化
    init(trigger: RepositoryViewModel.Input) {
        _input = trigger
        _output = RepositoryViewModel.Output.init(rx_repositories: createOutput())
    }
    
    func output() -> RepositoryViewModel.Output {
        return _output
    }
}

extension RepositoryViewModel {
    
    // InputからModel経由でOutputを生成する
    private func createOutput() -> Driver<[RepositoryInfo]> {
        
        return repositoryModel.rx_get(from: _input.repositoryName)
    }
}
