//
//  SearchBar.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import UIKit
import Then
import SnapKit

final class SearchBar: UITextField {
    
    private let magnifierImageView = UIImageView().then {
        $0.image = .mailplugThread.search
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        
        containerView.addSubview(magnifierImageView)
        
        magnifierImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        self.leftView = containerView
        self.leftViewMode = .always
        
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func setPlaceholder(placeholder: String) {
        self.placeholder = placeholder
    }
}
