//
//  SearchResultViewModel.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/18.
//

import RxSwift
import RxCocoa
import Foundation

enum SearchResultNavigation {
    case finish
}

final class SearchResultViewModel: ViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let rightButtonTapped: Observable<Void>
    }
    
    struct Output {
        let posts: Driver<[Post]>
        let search: Observable<Search>
    }
    
    var disposeBag = DisposeBag()
    
    private let posts = BehaviorSubject<[Post]>(value: [])
    var board = BehaviorSubject<Board>(value: Board.tempBoard())
    var search = BehaviorSubject<Search>(value: Search(category: .all, word: "", date: Date()))
    var navigation = PublishSubject<SearchResultNavigation>()
    
    var searchResultUseCase: SearchResultUseCaseProtocol?
    
    func transform(input: Input) -> Output {
        bindNavigation(input: input)
        
        input.viewDidLoad
            .withLatestFrom( Observable.combineLatest(board, search))
            .withUnretained(self)
            .flatMap { $0.0.searchResultUseCase?.fetchSearchResultList(boardID: $0.1.0.boardID, search: $0.1.1) ?? .empty() }
            .bind(to: posts)
            .disposed(by: disposeBag)
        
        return Output(
            posts: posts.asDriver(onErrorJustReturn: []),
            search: search
        )
    }
    
    func bindNavigation(input: Input) {
        input.rightButtonTapped
            .map { .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
