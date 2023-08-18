//
//  SearchRequestDTO.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import Foundation

struct SearchRequestDTO: Encodable {
    let search: String
    let searchTarget: SearchCategory
    let offset: Int = 0
    let limit: Int = 30
    
    // Enum 타입을 JSON 형식으로 변환하는 방법을 정의합니다.
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode("\(self)")
        }
    
}
