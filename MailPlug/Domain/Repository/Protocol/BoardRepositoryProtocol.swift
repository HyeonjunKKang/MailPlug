//
//  BoardRepositoryProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import RxSwift

protocol BoardRepositoryProtocol {
    func fetch() -> Observable<[Board]>
}
