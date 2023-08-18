//
//  SearchViewModel.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchResult {
    case finish
    case select(Search, Board)
}

final class SearchViewModel: ViewModel {
    struct Input {
        let cancleButtonTapped: Observable<Void>
        let searchClass: Observable<SearchClass>
        let searchWord: Observable<String>
        let selectedSearch: Observable<(SearchClass, Search)>
        let deleteButton: Observable<(SearchClass, Search)>
    }
    
    struct Output {
        let selectBoard: Observable<Board>
        let dataSource: Driver<[(SearchClass, Search)]>
    }
    
    var disposeBag = DisposeBag()
    let board = BehaviorSubject<Board>(value: Board.tempBoard())
    let dataSource = BehaviorSubject<[(SearchClass, Search)]>(value: [])
    let recentSearchRefresh = PublishSubject<Void>()
    var recentSearchUseCase: RecentSearchUseCaseProtocol?
    let navigation = PublishSubject<SearchResult>()
    
    func transform(input: Input) -> Output {
        
        bindNavigation(input: input)
        bindDelete(input: input)
        
        // 검색 단어가 들어온 경우 search일 때 search list를 보여줌
        input.searchWord
            .withLatestFrom(input.searchClass)
            .filter { $0 == .search }
            .withLatestFrom(input.searchWord)
            .compactMap { $0 }
            .map { word in
                var searchs: [Search] = []
                
                SearchCategory.allCases.forEach { category in
                    let search = Search(category: category, word: word, date: Date())
                    searchs.append(search)
                }
                
                let result = searchs.map { ( SearchClass.search, $0) }
                
                return result
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        // history일 경우 최근 검색 목록을 나타냄.
        input.searchClass
            .filter { $0 == .history }
            .withUnretained(self)
            .flatMap { $0.0.recentSearchUseCase?.list() ?? .empty() }
            .map { $0.map { (SearchClass.history, $0) } }
            .bind(to: dataSource)
            .disposed(by: disposeBag)

        return Output(
            selectBoard: board,
            dataSource: dataSource.asDriver(onErrorJustReturn: [])
        )
    }
    
    func bindNavigation(input: Input) {
        input.cancleButtonTapped
            .map { .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.selectedSearch
            .filter { $0.0 == .history }
            .withLatestFrom( Observable.combineLatest(input.selectedSearch, board))
            .map { .select($0.0.1, $0.1) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.selectedSearch
            .filter { $0.0 == .search}
            .withUnretained(self)
            .flatMap { $0.0.recentSearchUseCase?.save(search: $0.1.1) ?? .empty() }
            .withLatestFrom( Observable.combineLatest(input.selectedSearch, board))
            .map { .select($0.0.1, $0.1) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func bindDelete(input: Input) {
        input.deleteButton
            .filter { $0.0 == .history }
            .withUnretained(self)
            .flatMap { $0.0.recentSearchUseCase?.delete(search: $0.1.1) ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { $0.0.recentSearchRefresh.onNext(()) })
            .disposed(by: disposeBag)
        
        // 최근 검색 결과를 삭제한 경우 검색 목록을 새로고침
        recentSearchRefresh
            .withUnretained(self)
            .flatMap { $0.0.recentSearchUseCase?.list() ?? .empty() }
            .map { $0.map { (SearchClass.history, $0) } }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    }
}
