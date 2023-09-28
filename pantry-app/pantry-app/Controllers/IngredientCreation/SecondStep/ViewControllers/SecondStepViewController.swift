//
//  SecondStepViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 28/09/23.
//

import UIKit

// MARK: - FirstStepViewControllerDelegate

protocol SecondStepViewControllerDelegate: AnyObject {
    func incrementCreationStep(_ viewController: UIViewController, didCreate ingredient: Ingredient)
    func cancelCreationProcess(_ viewController: UIViewController)
}

// MARK: - FirstStepViewController

class SecondStepViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: SecondStepViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel: SecondStepViewControllerViewModel
    
    // MARK: - UI Components
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 0
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
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
    
    private let createButton: UIButton = {
        let continueButton = UIButton()
        continueButton.setTitle("Create", for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.layer.cornerRadius = 18
        continueButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        
        return continueButton
    }()
    
    // MARK: - IngredientCreationViewController Init Methods
    
    init(viewModel: SecondStepViewControllerViewModel) {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(didTapCloseButton))
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        view.backgroundColor = .white
        view.addSubview(mainVerticalStackView)
        hintLabel.text = "Final step"
        dateLabel.text = "Expiring date for \(viewModel.ingredient.name):"
        mainVerticalStackView.addArrangedSubview(hintLabel)
        //mainVerticalStackView.addArrangedSubview(textFieldsVerticalStackView)
        mainVerticalStackView.addArrangedSubview(horizontalStackView)
        
        mainVerticalStackView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(110)
            make.bottom.equalTo(view)
            make.right.equalTo(view).offset(-20)
            make.left.equalTo(view).offset(20)
        }
        
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(datePicker)
        
        mainVerticalStackView.addArrangedSubview(UIView())
        mainVerticalStackView.addArrangedSubview(createButton)
        mainVerticalStackView.addArrangedSubview(UIView())
        
        // Create a UIToolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([doneButton], animated: false)
        
    }
    
    // MARK: - UI Action
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func didTapCloseButton() {
        delegate?.cancelCreationProcess(self)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let selectedDate = sender.date
        viewModel.ingredient.expiringDate = sender.date
    }
    
    @objc func createButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.createButton.layer.opacity = 0.7
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.createButton.layer.opacity = 1
            }
        }
        
        delegate?.incrementCreationStep(self, didCreate: viewModel.ingredient)
    }
}

