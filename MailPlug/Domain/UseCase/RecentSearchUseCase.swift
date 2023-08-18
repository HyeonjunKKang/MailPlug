//
//  RecentSearchUseCase.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift

struct RecentSearchUseCase: RecentSearchUseCaseProtocol {
    var searchRepository: SearchRepositoryProtocol?
    
    func list() -> Observable<[Search]> {
        return searchRepository?.load() ?? .empty()
    }
    
    func save(search: Search) -> Observable<Void> {
        return (searchRepository?.delete(search: search) ?? .empty())
            .flatMap { searchRepository?.saveRecentSearch(search: search) ?? .empty() }
    }
    
    func delete(search: Search) -> Observable<Void> {
        return searchRepository?.delete(search: search) ?? .empty()
    }
}
