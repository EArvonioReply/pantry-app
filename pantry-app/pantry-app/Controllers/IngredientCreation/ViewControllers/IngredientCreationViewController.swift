//
//  IngredientCreationViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

// MARK: - IngredientCreationViewControllerDelegate

protocol IngredientCreationViewControllerDelegate: AnyObject {
    func ingredientCreationViewControllerDidPush(_ viewController: UIViewController)
}

// MARK: - IngredientCreationViewController

class IngredientCreationViewController: UIViewController {

    // MARK: - Public Properties
    
    weak var delegate: IngredientCreationViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel: IngredientCreationViewControllerViewModel
    
    // MARK: - IngredientCreationViewController Init Methods
    
    init(viewModel: IngredientCreationViewControllerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IngredientCreationViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
    }

}
