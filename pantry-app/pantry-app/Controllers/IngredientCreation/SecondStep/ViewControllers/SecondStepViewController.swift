//
//  SecondStepViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 28/09/23.
//

import UIKit

// MARK: - SecondStepViewControllerDelegate

protocol SecondStepViewControllerDelegate: AnyObject {
    func incrementCreationStep(_ viewController: UIViewController, didCreate ingredient: Ingredient)
    func cancelCreationProcess(_ viewController: UIViewController)
}

// MARK: - SecondStepViewController

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
        let createButton = UIButton()
        createButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        createButton.setTitle("Create", for: .normal)
        createButton.backgroundColor = .systemGray
        createButton.layer.cornerRadius = 18
        createButton.isEnabled = false
        
        return createButton
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
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(didTapCloseButton))
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .editingDidEnd)
        
        hintLabel.text = "Final step"
        dateLabel.text = "Expiring date for \(viewModel.ingredient.name):"
        
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(datePicker)
        mainVerticalStackView.addArrangedSubview(hintLabel)
        mainVerticalStackView.addArrangedSubview(horizontalStackView)
        mainVerticalStackView.addArrangedSubview(createButton)
        
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(110)
            make.right.equalTo(view).inset(20)
            make.left.equalTo(view).offset(20)
        }
    }
    
    // MARK: - UI Action
    
    @objc private func didTapCloseButton() {
        delegate?.cancelCreationProcess(self)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        viewModel.ingredient.expiringDate = sender.date
        createButton.isEnabled = true
        createButton.backgroundColor = .systemBlue
    }
    
    @objc func createButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.createButton.layer.opacity = Constants.buttonClickedOpacity
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.createButton.layer.opacity = Constants.buttonAtRestOpacity
            }
        }
        
        delegate?.incrementCreationStep(self, didCreate: viewModel.ingredient)
    }
}

