//
//  SearchResultUseCase.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift

struct SearchResultUseCase: SearchResultUseCaseProtocol{
    var postRepository: PostRepositoryProtocol?
    
    func fetchSearchResultList(boardID: Int, search: Search) -> Observable<[Post]> {
        return postRepository?.searchList(boardID: boardID, search: search) ?? .empty()
    }
}
