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
    func pantryViewControllerDidPresent() {
        //viewController.modalPresentationStyle = .fullScreen
        let ingredientCreationViewModel = IngredientCreationViewControllerViewModel()
        let viewController = IngredientCreationViewController(viewModel: ingredientCreationViewModel)
        let coordinator = BaseCoordinator(navigationController: navigationController, viewController: viewController)
        present(child: coordinator)
    }
    
    func pantryViewControllerDidPush(_ ingredient: Ingredient) {
        let ingredientViewModel = IngredientViewControllerViewModel(ingredient: ingredient)
        let viewController = IngredientViewController(viewModel: ingredientViewModel)
        let coordinator = BaseCoordinator(navigationController: navigationController, viewController: viewController)
        push(child: coordinator)
    }
    
    
}
