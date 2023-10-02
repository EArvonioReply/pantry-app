//
//  IngredientCreationCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

// MARK: - Creation Steps Enumeration

enum Step {
    case second, creation
}

// MARK: - StepCoordinatorDelegate

protocol StepCoordinatorDelegate: AnyObject {
    func moveToSecondStep(ingredient: Ingredient?)
    func confirmCreation(of ingredient: Ingredient)
    func cancelCreation()
}

// MARK: - IngredientCreationCoordinatorDelegate

protocol IngredientCreationCoordinatorDelegate: AnyObject {
    func ingredientCreationCoordinator(_ coordinator: IngredientCreationCoordinator, didCreate ingredient: Ingredient)
    func cancelIngredientCreation(_ coordinator: IngredientCreationCoordinator)
}

// MARK: - IngredientCreationCoordinator

final class IngredientCreationCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    var navigationController: UINavigationController
    var viewController: UIViewController
    var childrenCoordinators: [Coordinator] = []
    
    // MARK: - IngredientCreationCoordinatorDelegate delegate
    
    weak var delegate: IngredientCreationCoordinatorDelegate?
    
    // MARK: - Init Method
    
    init() {
        navigationController = UINavigationController()
        viewController = self.navigationController
        viewController.modalPresentationStyle = .fullScreen
        let firstStepCoordinator = FirstStepCoordinator(navigationController: navigationController)
        navigationController.viewControllers = [firstStepCoordinator.viewController]
        childrenCoordinators.append(firstStepCoordinator)
        
        firstStepCoordinator.delegate = self
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
    
}

// MARK: - StepCoordinatorDelegate Extension

extension IngredientCreationCoordinator: StepCoordinatorDelegate {
    func moveToSecondStep(ingredient: Ingredient?) {
        guard let ingredient else {
            delegate?.cancelIngredientCreation(self)
            return
        }
        let coordinator = SecondStepCoordinator(navigationController: navigationController, ingredient: ingredient)
        coordinator.delegate = self
        push(child: coordinator)
    }
    
    func confirmCreation(of ingredient: Ingredient) {
        delegate?.ingredientCreationCoordinator(self, didCreate: ingredient)
    }
    
    func cancelCreation() {
        delegate?.cancelIngredientCreation(self)
    }
}
