//
//  SearchTableViewCell.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class SearchTableViewCell: UITableViewCell, Identifiable {
    
    let timeLineImageView = UIImageView()
    
    let categoryLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 14)
    }
    
    let searchWord = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let rightButton = UIImageView()
    
    private let categorySubject = BehaviorSubject<(SearchClass, Search)>(value: (.history,Search(category: .all, word: "", date: Date())))
    private let deleteButtonTapSubject = PublishSubject<(SearchClass, Search)>()
    private var data: (SearchClass, Search)?
    private let disposeBag = DisposeBag()
    
    var deleteButtonTap: Observable<(SearchClass, Search)> {
        return deleteButtonTapSubject.asObservable()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonTapAction))
        rightButton.addGestureRecognizer(tapGesture)
        rightButton.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    @objc func deleteButtonTapAction() {
        guard let data = data else { return }
        deleteButtonTapSubject.onNext(data)
    }
    
    func configure(category: SearchClass, search: Search) {
        categorySubject.onNext((category, search))

        categorySubject
            .do(onNext: {self.data = $0})
            .bind(to: rx.searchClass)
            .disposed(by: disposeBag)

        switch category {
        case .history:
            timeLineImageView.snp.updateConstraints {
                $0.width.equalTo(20)
            }
            
            categoryLabel.snp.updateConstraints {
                $0.leading.equalTo(timeLineImageView.snp.trailing).offset(10)
            }
            
        case .search:
            timeLineImageView.snp.updateConstraints {
                $0.width.equalTo(0)
            }
            
            categoryLabel.snp.updateConstraints {
                $0.leading.equalTo(timeLineImageView.snp.trailing).offset(-8)
            }
        }
        
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        
        contentView.addSubview(timeLineImageView)
        
        timeLineImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.width.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLineImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(timeLineImageView)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(rightButton)
        
        rightButton.snp.makeConstraints {
            $0.height.width.equalTo(18)
            $0.centerY.equalTo(timeLineImageView)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        contentView.addSubview(searchWord)
        
        searchWord.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(2)
            $0.centerY.equalTo(timeLineImageView)
        }
        
        let divider = UIView().then {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        addSubview(divider)
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
}

extension Reactive where Base: SearchTableViewCell {
    var searchClass: Binder<(SearchClass, Search)>{
        return Binder(base) { base, data in
            
            base.categoryLabel.text = "\(data.1.category.rawValue) : "
            base.searchWord.text = data.1.word
            
            switch data.0 {
            case .history:
                base.timeLineImageView.image = .mailplugThread.clock
                base.rightButton.image = .mailplugThread.close
                
            case .search:
                base.timeLineImageView.image = nil
                base.rightButton.image = .mailplugThread.caretArrow
            }
        }
    }
}
