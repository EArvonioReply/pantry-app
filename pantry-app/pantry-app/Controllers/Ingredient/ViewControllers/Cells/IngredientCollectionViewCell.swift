//
//  IngredientCollectionViewCell.swift
//  pantry-app
//
//  Created by Marco Agizza on 11/10/23.
//

import UIKit

// MARK: - IngredientCollectionViewCellViewModel

struct IngredientCollectionViewCellViewModel {
    let recipe: Recipe
}

// MARK: - IngredientCollectionViewCell

class IngredientCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "IngredientCollectionViewCell"
    var viewModel: IngredientCollectionViewCellViewModel!
    
    // MARK: - UI Components
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor // it can change with recipe.missedIngredientCount
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1.0
        label.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    // MARK: - IngredientCollectionViewCell Configuration Methods
    
    public func configure(by viewModel: IngredientCollectionViewCellViewModel) {
        self.viewModel = viewModel
        recipeImageView.kf.setImage(with: URL(string: viewModel.recipe.photoUrl), placeholder: UIImage.Images.ingredientPlaceholder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(recipeImageView)
        self.addSubview(nameLabel)
        
        nameLabel.text = viewModel.recipe.title
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.layer.cornerRadius = 10.0
        recipeImageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        nameLabel.snp.makeConstraints { make in
            make.leftMargin.equalTo(self.snp_leftMargin).offset(10)
            make.bottomMargin.equalTo(self.snp_bottomMargin).offset(-10)
            make.width.equalTo(self.snp.width).offset(-20)
        }
    }
    
    // MARK: - UICollectionViewCell Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipeImageView.image = nil
        self.nameLabel.text = ""
    }
}
