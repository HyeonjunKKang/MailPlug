//
//  MenuViewModel.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/15.
//

import RxSwift
import RxCocoa

enum MenuResult {
    case back
    case select(Board)
}

final class MenuViewModel: ViewModel {
    
    struct Input {
        let closeButtonTapped: Observable<Void>
        let viewDidLoad: Observable<Void>
        let selectBoard: Observable<Board>
    }
    
    struct Output {
        let tableViewDataSource: Driver<[SectionOfBoard]>
    }
    
    let navigation = PublishSubject<MenuResult>()
    var boardUseCase: BoardUseCaseProtocol?
    private let boards = BehaviorSubject<[Board]>(value: [])
    private let tableViewDataSource = BehaviorSubject<[SectionOfBoard]>(
        value: [
            SectionOfBoard(
                header: Header(category: "게시판"),
                items: [
                    Board(
                        boardID: 123,
                        displayName: "임시",
                        boardType: "임시",
                        isFavorite: false,
                        hasNewPost: false,
                        orderNo: 0,
                        capability: Board.Capability(writable: false, manageable: true)
                        )
                    ]
                )
            ]
        )
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        bindNavigation(input: input)
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { $0.0.boardUseCase?.fetch() ?? .empty() }
            .bind(to: boards)
            .disposed(by: disposeBag)
        
        boards
            .map { [SectionOfBoard(header: Header(category: "게시판"), items: $0)] }
            .bind(to: tableViewDataSource)
            .disposed(by: disposeBag)
        
        return Output(
            tableViewDataSource: tableViewDataSource.asDriver(onErrorJustReturn: [])
        )
    }
    
    func bindNavigation(input: Input) {
        input.closeButtonTapped
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.selectBoard
            .map { .select($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
