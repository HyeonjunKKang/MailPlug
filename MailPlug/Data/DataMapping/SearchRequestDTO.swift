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
    
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode("\(self)")
        }
    
}
