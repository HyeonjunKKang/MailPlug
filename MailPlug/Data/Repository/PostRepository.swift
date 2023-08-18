//
//  PostRepository.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/16.
//

import RxSwift

struct PostRepository: PostRepositoryProtocol {
    
    var postService: PostServiceProtocol?
    var remoteSearchService: SearchServiceProtocol?
    
    func list(boardID: Int, offset: Int, limit: Int) -> Observable<[Post]> {
        let request = PostRequestDTO(boardID: boardID, offset: offset, limit: limit)
        
        return postService?.fetch(request: request)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func searchList(boardID: Int, search: Search) -> Observable<[Post]> {
        let request = SearchRequestDTO(search: search.word, searchTarget: search.category)
        
        return remoteSearchService?.fetch(boardID: boardID, request: request)
            .map { $0.toDomain() } ?? .empty()
    }
}
