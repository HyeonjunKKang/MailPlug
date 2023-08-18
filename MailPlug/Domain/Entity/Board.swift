//
//  Board.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation

struct Board {
    let boardID: Int
    let displayName, boardType: String
    let isFavorite, hasNewPost: Bool
    let orderNo: Int
    let capability: Capability
    
    struct Capability {
        let writable, manageable: Bool
    }
    
    static func tempBoard() -> Board {
        return Board(boardID: 0, displayName: "", boardType: "", isFavorite: false, hasNewPost: false, orderNo: 0, capability: Capability(writable: false, manageable: false))
    }
}
