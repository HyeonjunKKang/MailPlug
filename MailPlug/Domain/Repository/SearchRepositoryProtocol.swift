//
//  SearchRepositoryProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift

protocol SearchRepositoryProtocol {
    func saveRecentSearch(search: Search) -> Observable<Void>
    func load() -> Observable<[Search]>
    func delete(search: Search) -> Observable<Void>
}
