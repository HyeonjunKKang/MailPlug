//
//  SearchBar+Rx.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: SearchBar {
    var placeholderBoard: Binder<Board> {
        return Binder(base) { base, board in
            base.setPlaceholder(placeholder: "\(board.displayName)에서 검색")
        }
    }
    
    var placeholderSearch: Binder<Search> {
        return Binder(base) { base, search in
            let attributeString = NSMutableAttributedString(string: "\(search.category.rawValue) : \(search.word)")
            let categoryRange = NSRange(location: 0, length: search.category.rawValue.count + 2)
            let categoryAttribute: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 14),
            ]
            
            let wordRange = NSRange(location: search.category.rawValue.count + 3, length: search.word.count)
            let wordAttribute: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 16),
            ]
            
            
            attributeString.addAttributes(categoryAttribute, range: categoryRange)
            attributeString.addAttributes(wordAttribute, range: wordRange)
//
            base.attributedText = attributeString
        }
    }
}
