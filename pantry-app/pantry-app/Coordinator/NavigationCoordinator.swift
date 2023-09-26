//
//  NavigationCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit

protocol NavigationProvider {
    var navigationController: UINavigationController { get }
    
    func push(child: Coordinator, animated: Bool)
    func pop(child: Coordinator, animated: Bool, completion: (() -> Void)?)
}

extension NavigationProvider where Self: Coordinator {
    func push(child: Coordinator, animated: Bool = true) {
        add(child: child)
        navigationController.pushViewController(child.viewController, animated: animated)
    }
    
    func pop(child: Coordinator, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let coordinator = childrenCoordinators.first(where: { $0 === child }) {
            remove(child: coordinator)
            if coordinator.viewController.parent != nil {
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                navigationController.popViewController(animated: animated)
                CATransaction.commit()
            }
        }
    }
}

typealias NavigationCoordinator = Coordinator & NavigationProvider
