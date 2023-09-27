//
//  FirstStepViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

// MARK: - FirstStepViewControllerDelegate

protocol FirstStepViewControllerDelegate: AnyObject {
    func firstStepViewController(_ viewController: UIViewController, didCreate ingredient: Ingredient)
}

// MARK: - FirstStepViewController

class FirstStepViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: FirstStepViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel: FirstStepViewControllerViewModel
    
    // MARK: - UI Components
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter ingredient name"
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter quantity"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let mainVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 35
        
        return stackView
    }()
    
    private let textFieldsVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    // MARK: - IngredientCreationViewController Init Methods
    
    init(viewModel: FirstStepViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IngredientCreationViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .purple
        view.addSubview(mainVerticalStackView)
        hintLabel.text = "Register a new ingredient"
        mainVerticalStackView.addArrangedSubview(hintLabel)
        mainVerticalStackView.addArrangedSubview(textFieldsVerticalStackView)
        
        mainVerticalStackView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(90)
            make.bottom.equalTo(view)
            make.right.equalTo(view).offset(-20)
            make.left.equalTo(view).offset(20)
        }
        
        textFieldsVerticalStackView.addArrangedSubview(nameTextField)
        textFieldsVerticalStackView.addArrangedSubview(quantityTextField)
        
        mainVerticalStackView.addArrangedSubview(UIView())
        
        // Create a UIToolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([doneButton], animated: false)
        
        nameTextField.inputAccessoryView = toolbar
        quantityTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}

extension FirstStepViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField === nameTextField {
            viewModel.ingredient.name = textField.text ?? ""
        } else {
            viewModel.ingredient.quantity = Double(textField.text ?? "") ?? 0.0
        }
    }
}
