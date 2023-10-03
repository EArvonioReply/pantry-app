//
//  IngredientViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit
import Kingfisher
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
    
    // MARK: - UI Components
    
    private let mainVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let ingredientImage: UIImageView = {
        let ingredientImage = UIImageView()
        ingredientImage.image = UIImage(systemName: "fork.knife.circle.fill")
        ingredientImage.contentMode = .scaleAspectFit
        ingredientImage.layer.cornerRadius = 10
        
        return ingredientImage
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let expiringDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
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
        view.backgroundColor = .systemBackground
        setupUI()
        
    }
    
    private func setupUI() {
        nameLabel.text = viewModel.name
        quantityLabel.text = "\(viewModel.quantity) \(viewModel.unitOfMeasure)"
        expiringDateLabel.text = "Expiring date is \(viewModel.getFormattedDate())"
        ingredientImage.kf.setImage(with: URL(string: viewModel.photoUrl ?? ""), placeholder: UIImage(systemName: "fork.knife.circle.fill")!)
        ingredientImage.snp.makeConstraints { make in
            make.height.equalTo(view.frame.width - 20)
        }
        
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(ingredientImage)
        mainVerticalStackView.addArrangedSubview(horizontalStackView)
        mainVerticalStackView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(40)
            make.bottom.equalTo(view)
            make.right.equalTo(view).offset(-20)
            make.left.equalTo(view).offset(20)
        }
        
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.addArrangedSubview(quantityLabel)
        
        mainVerticalStackView.addArrangedSubview(expiringDateLabel)
        mainVerticalStackView.addArrangedSubview(UIView())
        
        
    }
    
}
