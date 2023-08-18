//
//  AppCoordinator.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/15.
//

import UIKit
import RxSwift
import Foundation

final class AppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        super.init(UINavigationController())
    }
    
    private func setup(with window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
    
    override func start() -> Observable<Void> {
        setup(with: window)
        showThread()
        return Observable.never()
    }
    
    private func showThread() {
        navigationController.setNavigationBarHidden(false, animated: true)
        let thread = ThreadCoordinator(navigationController)
        coordinate(to: thread)
            .subscribe(onNext: {
                switch $0 {
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}





