//
//  FirstStepCoordinator.swift
//  pantry-app
//
//  Created by utente on 27/09/23.
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
        let viewModel = FirstStepViewControllerViewModel(ingredient: Ingredient())
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
    func firstStepViewController(_ viewController: UIViewController, didCreate ingredient: Ingredient) {
        delegate?.update(ingredient: ingredient, andMoveTo: .second)
    }
}
