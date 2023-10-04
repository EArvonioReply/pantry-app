//
//  PantryCollectionViewCell.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - PantryCollectionViewCellViewModel

struct PantryCollectionViewCellViewModel {
    let ingredient: Ingredient
}

// MARK: - PantryCollectionViewCell

class PantryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PantryCollectionViewCell"
    var viewModel: PantryCollectionViewCellViewModel!
    
    // MARK: - UI Components
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemOrange
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1.0
        label.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    // MARK: - PantryCollectionViewCell Configuration Methods
    
    public func configure(by viewModel: PantryCollectionViewCellViewModel) {
        self.viewModel = viewModel
        myImageView.kf.setImage(with: URL(string: viewModel.ingredient.photoUrl ?? ""), placeholder: UIImage(systemName: "fork.knife.circle.fill")!)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(myImageView)
        self.addSubview(nameLabel)
        nameLabel.text = viewModel.ingredient.name
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.layer.cornerRadius = 10.0
        myImageView.snp.makeConstraints { make in
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
        self.myImageView.image = nil
    }
}
