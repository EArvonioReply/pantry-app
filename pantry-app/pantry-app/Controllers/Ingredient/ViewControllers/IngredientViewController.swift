//
//  IngredientViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

// MARK: - IngredientViewControllerDelegate

protocol IngredientViewControllerDelegate: AnyObject {
    func ingredientViewControllerDidPush(_ viewController: UIViewController)
}

// MARK: - IngredientViewController

class IngredientViewController: UIViewController {

    // MARK: - Public Properties
    
    weak var delegate: IngredientViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel: IngredientViewControllerViewModel
    
    // MARK: - IngredientViewController Init Methods
    
    init(viewModel: IngredientViewControllerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IngredientViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        print("Sto visualizzato l'ingrediente \(viewModel.name)")
        // Do any additional setup after loading the view.
    }

}
