//
//  Search.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import Foundation

enum SearchCategory: String, CaseIterable {
    case all = "전체"
    case title = "제목"
    case contents = "내용"
    case writer = "작성자"
}

enum SearchClass {
    case history
    case search
}

struct Search {
    let category: SearchCategory
    let word: String
    let date: Date
}
