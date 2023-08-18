//
//  ThreadUseCase.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/16.
//

import RxSwift

struct ThreadUseCase: ThreadUseCaseProtocol {
    
    var postRepository: PostRepositoryProtocol?
    
    func list(boardID: Int, offset: Int, limit: Int) -> Observable<[Post]> {
        return postRepository?.list(boardID: boardID, offset: offset, limit: limit) ?? .empty()
    }
}
