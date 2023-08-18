//
//  BoardUseCase.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import RxSwift

struct BoardUseCase: BoardUseCaseProtocol {
    var boardRepository: BoardRepositoryProtocol?
    
    func fetch() -> Observable<[Board]> {
        return boardRepository?.fetch() ?? .empty()
    }
}
