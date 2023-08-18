//
//  PostResponseDTO.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation

struct PostResponseDTO: Decodable {
    let value: [Value]
    let count, offset, limit, total: Int

    struct Value: Decodable {
        let postID: Int
        let title: String
        let boardID: Int
        let boardDisplayName: String
        let writer: Writer
        let contents: String
        let createdDateTime: String
        let viewCount: Int
        let postType: PostType
        let isNewPost, hasInlineImage: Bool
        let commentsCount, attachmentsCount: Int
        let isAnonymous, isOwner, hasReply: Bool
        let parentPostID: Int?

        enum CodingKeys: String, CodingKey {
            case postID = "postId"
            case title
            case boardID = "boardId"
            case boardDisplayName, writer, contents, createdDateTime, viewCount, postType, isNewPost, hasInlineImage, commentsCount, attachmentsCount, isAnonymous, isOwner, hasReply
            case parentPostID = "parentPostId"
        }
    }
    
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
                postType: Post.PostType(rawValue: $0.postType.rawValue) ?? .normal,
                isNewPost: $0.isNewPost,
                hasInlineImage: $0.hasInlineImage,
                commentsCount: $0.commentsCount,
                attachmentsCount: $0.attachmentsCount,
                isAnonymous: $0.isAnonymous,
                isOwner: $0.isOwner,
                hasReply: $0.hasReply,
                parentPostID: $0.parentPostID))
        }
        
        return posts
    }

    enum PostType: String, Decodable {
        case normal = "normal"
        case notice = "notice"
        case reply = "reply"
    }

    struct Writer: Decodable {
        let displayName: String
        let emailAddress: String
    }
}
