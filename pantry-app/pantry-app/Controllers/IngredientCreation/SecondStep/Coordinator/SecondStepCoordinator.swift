//
//  SecondStepCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 28/09/23.
//

import UIKit

final class SecondStepCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    var navigationController: UINavigationController
    var viewController: UIViewController
    var childrenCoordinators: [Coordinator] = []
    
    weak var delegate: StepCoordinatorDelegate?
    
    // MARK: - Init Method
    
    init(navigationController: UINavigationController, ingredient: Ingredient) {
        let viewModel = SecondStepViewControllerViewModel(ingredient: ingredient)
        let viewController = SecondStepViewController(viewModel: viewModel)
        self.navigationController = navigationController
        self.viewController = viewController
        
        viewController.delegate = self
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
    
}

// MARK: - PantryViewControllerDelegate

extension SecondStepCoordinator: SecondStepViewControllerDelegate {
    func incrementCreationStep(_ viewController: UIViewController, didCreate ingredient: Ingredient) {
        delegate?.confirmCreation(of: ingredient)
    }
    
    func cancelCreationProcess(_ viewController: UIViewController) {
        delegate?.cancelCreation()
    }
}
