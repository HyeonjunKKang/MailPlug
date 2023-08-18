//
//  BaseCoordinator.swift
//  MailPlug
//
//  Created by 강현준 on 2023/08/15.
//

import UIKit
import RxSwift

class BaseCoordinator<ResultType> {
    
    typealias CoordinationResult = ResultType
    
    private let identifier = String(describing: ResultType.self)
    private var childCoordinators: [String: Any] = [:]
    let navigationController: UINavigationController
    let disposeBag = DisposeBag()
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented!!")
    }
    
    // MARK: - Child Coordinator
    
    private func append<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func remove<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        append(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.remove(coordinator: coordinator) })
    }
    
    // MARK: - Push ∙ Pop
    
    func push(_ viewController: UIViewController, animated: Bool, isRoot: Bool = false) {
        if isRoot {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    func pop(animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            navigationController.viewControllers = []
        } else {
            navigationController.popViewController(animated: animated)
        }
    }
    
    // MARK: - Present
    
    func present(_ viewController: UIViewController, animated: Bool) {
        navigationController.present(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }

    // MARK: - Navigation Bar Hidden
    
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        navigationController.tabBarController?.navigationController?.setNavigationBarHidden(
            hidden,
            animated: animated
        )
    }
    
    func setTabBarHidden(_ hidden: Bool) {
        navigationController.tabBarController?.tabBar.isHidden = hidden
    }
}
