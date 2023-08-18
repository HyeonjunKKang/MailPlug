//
//  SearchServiceProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift

protocol SearchServiceProtocol {
    func fetch(boardID: Int, request: SearchRequestDTO) -> Observable<SearchResponseDTO>
}
