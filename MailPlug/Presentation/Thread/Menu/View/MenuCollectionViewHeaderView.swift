//
//  MenuTableViewHeader.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/16.
//

import UIKit
import SnapKit
import Then

final class MenuCollectionViewHeaderView: UICollectionReusableView, Identifiable {
    
    private let categoryNameLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(categoryNameLabel)
        
        categoryNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalToSuperview().offset(9)
            $0.bottom.equalToSuperview().inset(9)
        }
        
        let divider = UIView().then {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        addSubview(divider)
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(header: Header) {
        categoryNameLabel.text = header.category
    }
}
