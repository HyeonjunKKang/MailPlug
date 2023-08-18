//
//  SearchRepository.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import RxSwift

struct SearchRepository: SearchRepositoryProtocol {
    
    var localRecentSearchServicel: LocalSearchServiceProtocol?
    
    func saveRecentSearch(search: Search) -> Observable<Void> {
        return localRecentSearchServicel?.saveRecentSearch(word: search.word, category: search.category.rawValue, date: search.date) ?? .empty()
    }
    
    func load() -> Observable<[Search]> {
        return localRecentSearchServicel?.loadFromCoreData(request: NSSearch.fetchRequest())
            .map { $0.map { $0.toDomain() } }
            .compactMap { $0.compactMap { $0 } }
            .map { $0.sorted { $0.date > $1.date }} ?? .empty()
    }
    
    func delete(search: Search) -> Observable<Void> {
        return localRecentSearchServicel?.delete(search: search, request: NSSearch.fetchRequest()) ?? .empty()
    }
}
