//
//  Identifiable.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/15.
//

import Foundation

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { return "\(self)" }
}


