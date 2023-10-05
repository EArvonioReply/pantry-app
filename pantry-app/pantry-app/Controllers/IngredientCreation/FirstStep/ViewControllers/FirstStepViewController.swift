//
//  FirstStepViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

// MARK: - FirstStepViewControllerDelegate

protocol FirstStepViewControllerDelegate: AnyObject {
    func incrementCreationStep(_ viewController: UIViewController, didCreate ingredient: Ingredient)
    func cancelCreationProcess(_ viewController: UIViewController)
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
    
    private let unitOfMeasuresPicker: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private let unitOfMeasureTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Choose unit of measure to use"
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
    
    private let continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .systemGray
        continueButton.layer.cornerRadius = 18
        continueButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        continueButton.isEnabled = false
        
        return continueButton
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
        view.backgroundColor = .systemBackground
        nameTextField.delegate = self
        quantityTextField.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(didTapCloseButton))
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        view.addSubview(mainVerticalStackView)
        hintLabel.text = "Register a new ingredient"
        mainVerticalStackView.addArrangedSubview(hintLabel)
        mainVerticalStackView.addArrangedSubview(textFieldsVerticalStackView)
        
        mainVerticalStackView.snp.makeConstraints { make in
            make.topMargin.equalTo(view.snp_topMargin).offset(10)
            make.rightMargin.equalTo(view.snp_rightMargin).offset(-10)
            make.leftMargin.equalTo(view.snp_leftMargin).offset(10)
        }
        
        unitOfMeasuresPicker.delegate = self
        unitOfMeasuresPicker.dataSource = self
        unitOfMeasureTextField.inputView = unitOfMeasuresPicker
        
        textFieldsVerticalStackView.addArrangedSubview(nameTextField)
        textFieldsVerticalStackView.addArrangedSubview(unitOfMeasureTextField)
        textFieldsVerticalStackView.addArrangedSubview(quantityTextField)
        mainVerticalStackView.addArrangedSubview(UIView())
        mainVerticalStackView.addArrangedSubview(continueButton)
        mainVerticalStackView.addArrangedSubview(UIView())
        
        // Create a UIToolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([doneButton], animated: false)
        
        nameTextField.inputAccessoryView = toolbar
        quantityTextField.inputAccessoryView = toolbar
        unitOfMeasureTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - UI Action
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func didTapCloseButton() {
        delegate?.cancelCreationProcess(self)
    }
    
    @objc private func continueButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.continueButton.layer.opacity = 0.7
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.continueButton.layer.opacity = 1
            }
        }
        delegate?.incrementCreationStep(self, didCreate: viewModel.ingredient)
    }
}

extension FirstStepViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField === nameTextField {
            viewModel.ingredient.name = textField.text ?? ""
        } else if textField === quantityTextField {
            viewModel.ingredient.quantity = Double(textField.text ?? "") ?? 0.0
        } else {
            switch textField.text {
            case "litres":
                viewModel.ingredient.unitOfMeasure = .litres
            case "kilograms":
                viewModel.ingredient.unitOfMeasure = .kilograms
            case "grams":
                viewModel.ingredient.unitOfMeasure = .grams
            default:
                viewModel.ingredient.unitOfMeasure = .pieces
            }
            
        }
        if nameTextField.text != "" && quantityTextField.text != "" {
            continueButton.backgroundColor = .systemBlue
            continueButton.isEnabled = true
        } else {
            continueButton.backgroundColor = .systemGray
            continueButton.isEnabled = false
        }
    }
}

extension FirstStepViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.unitsOfMeasure.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.unitsOfMeasure[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unitOfMeasureTextField.text = viewModel.unitsOfMeasure[row]
        textFieldDidEndEditing(unitOfMeasureTextField, reason: .committed)
    }
    
}
