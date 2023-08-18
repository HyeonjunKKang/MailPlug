//
//  SearchResponseDTO.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import Foundation

struct SearchResponseDTO: Codable {
    let value: [Value]
    let count, offset, limit, total: Int
    
    func toDomain() -> [Post] {
        var posts: [Post] = []
        
        value.forEach {
            posts.append(Post(
                postID: $0.postID,
                title: $0.title,
                boardID: $0.boardID,
                boardDisplayName: $0.boardDisplayName,
                writer: Post.Writer(displayName: $0.writer.displayName, emailAddress: $0.writer.emailAddress),
                contents: $0.contents,
                createdDateTime: $0.createdDateTime,
                viewCount: $0.viewCount,
                postType: Post.PostType.normal,
                isNewPost: $0.isNewPost,
                hasInlineImage: $0.hasInlineImage,
                commentsCount: $0.commentsCount,
                attachmentsCount: $0.attachmentsCount,
                isAnonymous: $0.isAnonymous,
                isOwner: $0.isOwner,
                hasReply: $0.hasReply,
                parentPostID: 0))
        }
        
        return posts
    }
}

struct Value: Codable {
    let postID: Int
    let title: String
    let boardID: Int
    let boardDisplayName: String
    let writer: Writer
    let contents: String
    let createdDateTime: String
    let viewCount: Int
    let postType: String
    let isNewPost, hasInlineImage: Bool
    let commentsCount, attachmentsCount: Int
    let isAnonymous, isOwner, hasReply: Bool

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title
        case boardID = "boardId"
        case boardDisplayName, writer, contents, createdDateTime, viewCount, postType, isNewPost, hasInlineImage, commentsCount, attachmentsCount, isAnonymous, isOwner, hasReply
    }
}

// MARK: - Writer
struct Writer: Codable {
    let displayName, emailAddress: String
}
