//
//  NavigationView.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import UIKit

class NavigationView: UIView {
    
    // titleView를 변경하면 터치이벤트가 발생하지 않는 오류 해결을 위해
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
