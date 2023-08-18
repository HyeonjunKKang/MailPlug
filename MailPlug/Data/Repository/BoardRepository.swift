//
//  BoardRepository.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation
import RxSwift

struct BoardRepository: BoardRepositoryProtocol {
    var boardDataSource: BoardServiceProtocol?
    
    func fetch() -> Observable<[Board]> {
        return boardDataSource?.fetch()
            .map { $0.toDomain().sorted { $0.boardID < $1.boardID} } ?? .empty()
            
    }
}
