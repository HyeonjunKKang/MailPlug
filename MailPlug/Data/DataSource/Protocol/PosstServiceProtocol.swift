//
//  PosstServiceProtocol.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/16.
//

import RxSwift

protocol PostServiceProtocol {
    func fetch(request: PostRequestDTO) -> Observable<PostResponseDTO>
}
