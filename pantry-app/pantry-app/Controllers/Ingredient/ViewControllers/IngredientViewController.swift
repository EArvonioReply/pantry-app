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
    
    // MARK: - IngredientViewController Init Methods
    
    init(viewModel: IngredientViewControllerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.loadData { [weak self] in
            self?.recipesCollectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let mainVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 11
        
        return stackView
    }()
    
    private let firstVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let secondVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        
        return stackView
    }()
    
    private let ingredientImage: UIImageView = {
        let ingredientImage = UIImageView()
        ingredientImage.image = .Images.ingredientPlaceholder
        ingredientImage.contentMode = .scaleAspectFit
        ingredientImage.layer.cornerRadius = 10
        ingredientImage.backgroundColor = .blue
        
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
    
    private let recipesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(IngredientCollectionViewCell.self, forCellWithReuseIdentifier: IngredientCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        return collectionView
    }()
    
    // MARK: - IngredientViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        
    }
    
    private func setupUI() {
        nameLabel.text = viewModel.name
        quantityLabel.text = "\(viewModel.quantity) \(viewModel.unitOfMeasure)"
        expiringDateLabel.text = "Expiring date is \(viewModel.getFormattedDate())"
        recipesLabel.text = "Possible recipes:"
        
        ingredientImage.kf.setImage(with: URL(string: viewModel.photoUrl ?? ""), placeholder: UIImage.Images.ingredientPlaceholder)
        ingredientImage.snp.makeConstraints { make in
            make.height.equalTo(view.frame.width)
        }
        
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(ingredientImage)
        firstVerticalStackView.addArrangedSubview(horizontalStackView)
        mainVerticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
        }
        let size = (view.frame.width/2) - 1.5 - 8.8
        recipesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(size + (size/4))
        }
        firstVerticalStackView.addArrangedSubview(expiringDateLabel)
        secondVerticalStackView.addArrangedSubview(recipesLabel)
        secondVerticalStackView.addArrangedSubview(recipesCollectionView)
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.addArrangedSubview(quantityLabel)
        mainVerticalStackView.addArrangedSubview(firstVerticalStackView)
        mainVerticalStackView.addArrangedSubview(secondVerticalStackView)
        mainVerticalStackView.addArrangedSubview(UIView())
    }
    
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource Extension

extension IngredientViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRecipes
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionViewCell.identifier, for: indexPath) as? IngredientCollectionViewCell else {
            fatalError("Failed to dequeue CustomCollectionViewCell in CollectionViewController")
        }
        cell.configure(by: IngredientCollectionViewCellViewModel(recipe: viewModel.getRecipe(at: indexPath.row)))
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extension

extension IngredientViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Size: subtract (HorizontalSpacing*Separators)/NumberOfItems + collection view offset: (2*1)/2
        let size = (view.frame.width/2) - 1.5 - 8.8
        return CGSize(width: size, height: size + (size/4))
    }
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    // Horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
