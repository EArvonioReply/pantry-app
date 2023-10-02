//
//  FirstStepCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 28/09/23.
//

import UIKit

final class FirstStepCoordinator: NavigationCoordinator {
    
    // MARK: - NavigationCoordinator Properties
    
    var navigationController: UINavigationController
    var viewController: UIViewController
    var childrenCoordinators: [Coordinator] = []
    
    weak var delegate: StepCoordinatorDelegate?
    
    // MARK: - Init Method
    
    init(navigationController: UINavigationController) {
        let viewModel = FirstStepViewControllerViewModel()
        let viewController = FirstStepViewController(viewModel: viewModel)
        self.navigationController = navigationController
        self.viewController = viewController
        
        viewController.delegate = self
    }
    
    // MARK: - Coordinator Method
    
    func start() {}
    
}

// MARK: - PantryViewControllerDelegate

extension FirstStepCoordinator: FirstStepViewControllerDelegate {
    func incrementCreationStep(_ viewController: UIViewController, didCreate ingredient: Ingredient) {
        delegate?.moveToSecondStep(ingredient: ingredient)
    }
    
    func cancelCreationProcess(_ viewController: UIViewController) {
        delegate?.cancelCreation()
    }
}
