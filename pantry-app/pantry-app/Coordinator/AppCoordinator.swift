//
//  AppCoordinator.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit

typealias AppCoordinator = Coordinator & WindowProvider

protocol WindowProvider: AnyObject {
    var window: UIWindow { get }
}

extension WindowProvider where Self: Coordinator {
    func switchTo(coordinator: Coordinator) {
        remove(children: childrenCoordinators)
        add(child: coordinator)
        window.rootViewController = coordinator.viewController
        window.makeKeyAndVisible()
        coordinator.start()
    }
}
