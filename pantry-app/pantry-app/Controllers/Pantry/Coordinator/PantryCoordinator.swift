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
        let coordinator = IngredientCreationCoordinator()
        coordinator.delegate = self
        present(child: coordinator)
    }
    
    func pantryViewControllerDidPush(_ ingredient: Ingredient) {
        let coordinator = IngredientCoordinator(ingredient: ingredient, navigationController: self.navigationController)
        push(child: coordinator)
    }
    
    
}

// MARK: - IngredientCreationCoordinatorDelegate Extension

extension PantryCoordinator: IngredientCreationCoordinatorDelegate {
    func ingredientCreationCoordinator(_ coordinator: IngredientCreationCoordinator, didCreate ingredient: Ingredient) {
        if let pantryNavigationViewController = viewController as? UINavigationController {
            let pantryViewController = pantryNavigationViewController.viewControllers.first as! PantryViewController
            pantryViewController.add(new: ingredient)
            dismiss(child: coordinator)
        }
    }
    
    func cancelIngredientCreation(_ coordinator: IngredientCreationCoordinator) {
        dismiss(child: coordinator)
    }
}
