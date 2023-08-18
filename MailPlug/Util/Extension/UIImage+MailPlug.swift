//
//  UIImage+MailPlug.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import UIKit

extension UIImage {
    static let mailplugThread = MailPlugThread()
}

struct MailPlugThread {
    let hambergerMenu = UIImage(named: "HambergerMenu")
    let magnifyingGlass = UIImage(named: "MagnifyingGlass")
    let close = UIImage(named: "Close")
    let badgeNotice = UIImage(named: "badgeNotice")
    let attached = UIImage(named: "Attached")
    let newIcon = UIImage(named: "NewIcon")
    let eye = UIImage(named: "Eye")
    let badgeReply = UIImage(named: "badgeReply")
    let illust = UIImage(named: "Illust")
    let search = UIImage(named: "Search")
    let clock = UIImage(named: "ClockClockwise")
    let caretArrow = UIImage(named: "caret-arrow")
    let illustnoRecentSearch = UIImage(named: "Illust-noRecentSearch")
    let illustnoSearchResult = UIImage(named: "Illust-noSearchResult")
}
