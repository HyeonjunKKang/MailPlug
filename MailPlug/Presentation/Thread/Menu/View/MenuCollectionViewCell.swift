//
//  MenuTableViewCell.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/15.
//

import UIKit
import RxSwift
import Then
import SnapKit

final class MenuCollectionViewCell: UICollectionViewCell, Identifiable {
    
    private let boardNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    let board = PublishSubject<Board>()
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.addSubview(boardNameLabel)
        boardNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    func bind() {
        board
            .map { $0.displayName }
            .bind(to: boardNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func configure(board: Board) {
        self.board.onNext(board)
    }
}
