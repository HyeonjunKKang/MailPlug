//
//  RecentSearchUseCaseProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift

protocol RecentSearchUseCaseProtocol {
    func list() -> Observable<[Search]>
    func save(search: Search) -> Observable<Void>
    func delete(search: Search) -> Observable<Void>
}
