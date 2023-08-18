//
//  String+Date.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/16.
//

import Foundation

extension String{
    func toDate() -> Date{
        if let date = ISO8601DateFormatter().date(from: self) {
            return date
        } else {
            fatalError("Can not convert")
        }
    }
}
