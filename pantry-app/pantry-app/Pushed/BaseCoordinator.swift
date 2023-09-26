//
//  BaseCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit

final class BaseCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    let navigationController: UINavigationController
    var childrenCoordinators: [Coordinator] = []
    let viewController: UIViewController
    
    // MARK: - Init Method
    
    init(navigationController: UINavigationController) {
        let viewController = UIViewController()
        self.navigationController = navigationController
        self.viewController = viewController
        viewController.view.backgroundColor = .magenta
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
}
