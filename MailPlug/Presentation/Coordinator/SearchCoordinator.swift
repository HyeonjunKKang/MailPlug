//
//  SearchCoordinator.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/17.
//

import UIKit
import RxSwift

enum SearchCoordinatorResult {
    case finish
}

final class SearchCoordinator: BaseCoordinator<SearchCoordinatorResult> {
    
    let finish = PublishSubject<SearchCoordinatorResult>()
    let selectBoard: Board
    
    override func start() -> Observable<SearchCoordinatorResult> {
        showSearch()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish: self?.pop(animated: false)
                }
            })
    }
    
    init(board: Board, _ navigationController: UINavigationController) {
        self.selectBoard = board
        super.init(navigationController)
    }
    
    func showSearch() {
        
        guard let viewModel = DIContainer.shared.container.resolve(SearchViewModel.self) else { return }
        
        viewModel.board
            .onNext(selectBoard)
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case.select(let data):
                    self?.showSearchResult(search: data.0, board: data.1)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = SearchViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    func showSearchResult(search: Search, board: Board) {
        
        guard let viewModel = DIContainer.shared.container.resolve(SearchResultViewModel.self) else { return }
        
        viewModel.search.onNext(search)
        viewModel.board.onNext(board)
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.pop(animated: true)
                default:
                    break
                }
            })
        
        let viewController = SearchResultViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
}
