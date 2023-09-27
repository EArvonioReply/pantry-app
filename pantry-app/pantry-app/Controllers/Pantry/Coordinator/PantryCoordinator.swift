//
//  PantryCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit

final class PantryCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    var navigationController: UINavigationController
    var viewController: UIViewController
    var childrenCoordinators: [Coordinator] = []
    
    // MARK: - Init Method
    
    init() {
        let viewController = PantryViewController(viewModel: PantryViewControllerViewModel())
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.viewController = self.navigationController
        
        viewController.delegate = self
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
    
}

// MARK: - PantryViewControllerDelegate

extension PantryCoordinator: PantryViewControllerDelegate {
    func pantryViewControllerDidPresent(_ viewController: UIViewController) {
        //viewController.modalPresentationStyle = .fullScreen
        let coordinator = BaseCoordinator(navigationController: navigationController, viewController: viewController)
        present(child: coordinator)
    }
    
    func pantryViewControllerDidPush(_ viewController: UIViewController) {
        let coordinator = BaseCoordinator(navigationController: navigationController, viewController: viewController)
        push(child: coordinator)
    }
    
    
}
