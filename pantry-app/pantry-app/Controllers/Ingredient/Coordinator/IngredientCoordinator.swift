//
//  IngredientCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

final class IngredientCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    var navigationController: UINavigationController
    var viewController: UIViewController
    var childrenCoordinators: [Coordinator] = []
    
    // MARK: - Init Method
    
    init(ingredient: Ingredient, navigationController: UINavigationController) {
        let viewModel = IngredientViewControllerViewModel(ingredient: ingredient)
        let viewController = IngredientViewController(viewModel: viewModel)
        self.navigationController = navigationController
        self.viewController = viewController
        
        viewController.delegate = self
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
    
}

// MARK: - PantryViewControllerDelegate

extension IngredientCoordinator: IngredientViewControllerDelegate {
    func ingredientViewControllerDidPush(_ viewController: UIViewController) {
        let coordinator = BaseCoordinator(navigationController: navigationController)
        push(child: coordinator)
    }
    
}
