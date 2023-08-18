//
//  BoardServiceProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import RxSwift

protocol BoardServiceProtocol {
    func fetch() -> Observable<BoardResponseDTO>
}
