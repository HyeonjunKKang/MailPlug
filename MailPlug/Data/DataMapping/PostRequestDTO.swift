//
//  PostRequestDTO.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation

struct PostRequestDTO: Encodable {
    let boardID: Int
    let offset: Int
    let limit: Int
}
