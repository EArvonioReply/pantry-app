//
//  IngredientCreationCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

enum Step {
    case second, creation
}

protocol StepCoordinatorDelegate: AnyObject {
    func update(ingredient: Ingredient, andMoveTo step: Step)
}

protocol IngredientCreationCoordinatorDelegate: AnyObject {
    func ingredientCreationCoordinator(_ coordinator: IngredientCreationCoordinator, didCreate ingredient: Ingredient)
}

final class IngredientCreationCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    var navigationController: UINavigationController
    var viewController: UIViewController
    var childrenCoordinators: [Coordinator] = []
    
    weak var delegate: IngredientCreationCoordinatorDelegate?
    
    private var ingredient: Ingredient?
    
    // MARK: - Init Method
    
    init() {
        self.navigationController = UINavigationController()
        let coordinator = FirstStepCoordinator(navigationController: navigationController)
        self.viewController = self.navigationController
        self.navigationController.viewControllers = [coordinator.viewController]
        self.childrenCoordinators.append(coordinator)
        
        coordinator.delegate = self
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
    
}

// MARK: - PantryViewControllerDelegate

extension IngredientCreationCoordinator: StepCoordinatorDelegate {
    func update(ingredient: Ingredient, andMoveTo step: Step) {
        self.ingredient = ingredient
        
        switch step {
        case .second:
            break
//            let coordinator = SecondStepCoordinator(ingredient: ingredient, navigationController: navigationController)
//            push(child: coordinator)
        case .creation:
            delegate?.ingredientCreationCoordinator(self, didCreate: ingredient)
        default:
            break
        }
    }
}
