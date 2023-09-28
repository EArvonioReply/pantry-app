//
//  IngredientCreationCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

// MARK: - Creation Steps Enumeration

enum Step {
    case second, creation, cancellation
}

// MARK: - StepCoordinatorDelegate

protocol StepCoordinatorDelegate: AnyObject {
    func update(ingredient: Ingredient?, andMoveTo step: Step)
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
    
    weak var delegate: IngredientCreationCoordinatorDelegate?
    
    private var ingredient: Ingredient?
    
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
    func update(ingredient: Ingredient?, andMoveTo step: Step) {
        self.ingredient = ingredient
        switch step {
        case .second:
            let coordinator = SecondStepCoordinator(navigationController: navigationController, ingredient: ingredient!)
            coordinator.delegate = self
            push(child: coordinator)
        case .creation:
            delegate?.ingredientCreationCoordinator(self, didCreate: ingredient!)
        case .cancellation:
            delegate?.cancelIngredientCreation(self)
        }
    }
}
