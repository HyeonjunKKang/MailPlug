//
//  ThreadCoordinator.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/15.
//

import UIKit
import RxSwift

enum ThreadCoordinatorResult {
    case finish
}

final class ThreadCoordinator: BaseCoordinator<ThreadCoordinatorResult> {
    
    let finish = PublishSubject<ThreadCoordinatorResult>()
    let selectBoard = PublishSubject<Board>()
    
    override func start() -> Observable<ThreadCoordinatorResult> {
        navigationController.setNavigationBarHidden(false, animated: true)
        showThread()
        return finish
    }
    
    func showThread() {
        
        guard let viewModel = DIContainer.shared.container.resolve(ThreadViewModel.self) else { return }
        
        selectBoard
            .bind(to: viewModel.currentBoard)
            .disposed(by: disposeBag)
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .menu:
                    self?.showMenu()
                case .search(let board):
                    self?.showSearch(board)
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = ThreadViewController(viewModel: viewModel)
        push(viewController, animated: true, isRoot: true)
    }
    
    func showMenu() {
        guard let viewModel = DIContainer.shared.container.resolve(MenuViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext:  { [weak self] in
                switch $0 {
                case .back:
                    self?.dismiss(animated: true)
                case.select(let data):
                    self?.selectBoard.onNext(data)
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = MenuViewController(viewModel: viewModel)
        self.present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    func showSearch(_ board: Board) {
        let search = SearchCoordinator(board: board, navigationController)
        
        coordinate(to: search)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

