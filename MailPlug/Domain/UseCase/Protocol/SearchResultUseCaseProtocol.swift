//
//  SearchResultUseCaseProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift

protocol SearchResultUseCaseProtocol {
    func fetchSearchResultList(boardID: Int, search: Search) -> Observable<[Post]>
}
