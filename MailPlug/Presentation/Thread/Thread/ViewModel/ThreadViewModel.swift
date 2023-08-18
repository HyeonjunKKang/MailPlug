//
//  ThreadViewModel.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/14.
//

import Foundation
import RxSwift
import RxCocoa

enum ThreadResult {
    case finish
    case menu
    case search(Board)
}

final class ThreadViewModel: ViewModel {
    
    struct Input{
        let viewDidLoad: Observable<Void>
        let menuButtonTapped: Observable<Void>
        let searchButtonTapped: Observable<Void>
        let scrollWillEnd: Observable<Void>
    }
    
    struct Output {
        let currentBoard: Driver<Board>
        let posts: Driver<[Post]>
    }
    
    var disposeBag = DisposeBag()
    var boardUseCase: BoardUseCaseProtocol? = DIContainer.shared.container.resolve(BoardUseCaseProtocol.self)
    var threadUseCase: ThreadUseCaseProtocol? = DIContainer.shared.container.resolve(ThreadUseCaseProtocol.self)
    
    private let posts = BehaviorSubject<[Post]>(value: [])
    var currentBoard = BehaviorSubject<Board>(value: Board.tempBoard())
    var search = BehaviorSubject<Search>(value: Search(category: .all, word: "", date: Date()))
    var isLoading: Bool = false
    let navigation = PublishSubject<ThreadResult>()
    
    func transform(input: Input) -> Output {
        bindNavigation(input: input)
        
        let newPost = BehaviorSubject<[Post]>(value: [])
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { $0.0.boardUseCase?.fetch() ?? .empty() }
            .map { $0.first }
            .compactMap { $0 }
            .bind(to: currentBoard)
            .disposed(by: disposeBag)
        
        currentBoard
            .skip(1)
            .withUnretained(self)
            .flatMap { $0.0.threadUseCase?.list(boardID: $0.1.boardID, offset: 0, limit: 30) ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.posts.onNext([])
                newPost.onNext($0.1)
            })
            .disposed(by: disposeBag)
        
        newPost
            .withLatestFrom(posts) {
                ($0 + $1).sorted { (post1, post2) -> Bool in
                    let postTypeOrder: [Post.PostType] = [.notice, .reply, .normal]
                    
                    guard let index1 = postTypeOrder.firstIndex(of: post1.postType),
                          let index2 = postTypeOrder.firstIndex(of: post2.postType) else {
                        return false
                    }
                    
                    if index1 != index2 {
                        return index1 < index2
                    } else if index1 == index2 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        
                        if let date1 = dateFormatter.date(from: post1.createdDateTime),
                           let date2 = dateFormatter.date(from: post2.createdDateTime) {
                            return date1 < date2
                        }
                    }
                    
                    return false
                }
            }
            .bind(to: posts)
            .disposed(by: disposeBag)
        
        input.scrollWillEnd
            .skip(1)
            .withLatestFrom(Observable.combineLatest(currentBoard, posts))
            .withUnretained(self)
            .flatMap {
                $0.0.isLoading = true
                return $0.0.threadUseCase?.list(boardID: $0.1.0.boardID, offset: $0.1.1.count - 1, limit: 30) ?? .empty() }
            .subscribe(onNext: {[weak self] in
                self?.isLoading = false
                newPost.onNext($0)
            })
            .disposed(by: disposeBag)
        
        return Output(
            currentBoard: currentBoard.asDriver(onErrorJustReturn: Board.tempBoard()),
            posts: posts.asDriver(onErrorJustReturn: [])
        )
    }
    
    func bindNavigation(input: Input) {
        input.searchButtonTapped
            .withLatestFrom(currentBoard)
            .map{ .search($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.menuButtonTapped
            .map { .menu }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
