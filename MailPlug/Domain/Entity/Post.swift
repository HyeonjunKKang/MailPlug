//
//  Post.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation

struct Post {
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
    
    struct Writer {
        let displayName: String
        let emailAddress: String
    }
    
    enum PostType: String {
        case normal = "normal"
        case notice = "notice"
        case reply = "reply"
    }
}
