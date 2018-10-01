//
//  RepositoryModel.swift
//  rxswf-API-demo
//
//  Created by S.Emoto on 2018/10/01.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import Foundation
import RxSwift

final class RepositoryModel {
    
    func get(request: GitHubAPI.SearchRepositories) -> Observable<[RepositoryInfo]> {
        
        return APIClient().get(withRequest: request)
    }
}
