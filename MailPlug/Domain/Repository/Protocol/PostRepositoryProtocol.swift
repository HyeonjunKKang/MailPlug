//
//  PostRepositoryProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/16.
//

import RxSwift

protocol PostRepositoryProtocol {
    func list(boardID: Int, offset: Int, limit: Int) -> Observable<[Post]>
    func searchList(boardID: Int, search: Search) -> Observable<[Post]>
}
