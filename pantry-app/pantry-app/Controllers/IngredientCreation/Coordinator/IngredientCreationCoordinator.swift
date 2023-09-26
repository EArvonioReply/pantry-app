//
//  IngredientCreationCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

final class IngredientCreationCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    var navigationController: UINavigationController
    var viewController: UIViewController
    var childrenCoordinators: [Coordinator] = []
    
    // MARK: - Init Method
    
    init(viewModel: IngredientCreationViewControllerViewModel) {
        let viewController = IngredientCreationViewController(viewModel: viewModel)
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.viewController = self.navigationController
        
        viewController.delegate = self
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
    
}

// MARK: - PantryViewControllerDelegate

extension IngredientCreationCoordinator: IngredientCreationViewControllerDelegate {
    
    func ingredientCreationViewControllerDidPush(_ viewController: UIViewController) {
        let coordinator = BaseCoordinator(navigationController: navigationController)
        push(child: coordinator)
    }
    
    
}
