//
//  BoardResponseDTO.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation

struct BoardResponseDTO: Decodable {
    let value: [Value]
    let count, offset, limit, total: Int
    
    func toDomain() -> [Board] {
        var boards: [Board] = []
        
        value.forEach {
            let board = Board(
                boardID: $0.boardID,
                displayName: $0.displayName,
                boardType: $0.boardType,
                isFavorite: $0.isFavorite,
                hasNewPost: $0.hasNewPost,
                orderNo: $0.orderNo,
                capability: Board.Capability(writable: $0.capability.writable, manageable: $0.capability.manageable)
            )
            
            boards.append(board)
        }
        
        return boards
    }
    
    struct Value: Decodable {
        let boardID: Int
        let displayName, boardType: String
        let isFavorite, hasNewPost: Bool
        let orderNo: Int
        let capability: Capability
        
        enum CodingKeys: String, CodingKey {
            case boardID = "boardId"
            case displayName, boardType, isFavorite, hasNewPost, orderNo, capability
        }
    }

    struct Capability: Codable {
        let writable, manageable: Bool
    }
}


