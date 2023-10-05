//
//  PantryCollectionViewCell.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit
import SnapKit
import Kingfisher

protocol PantryCollectionViewCellDelegate: AnyObject {
    func deleteCollectionItem(_ pantryCollectionViewCell: PantryCollectionViewCell)
}

// MARK: - PantryCollectionViewCellViewModel

struct PantryCollectionViewCellViewModel {
    let ingredient: Ingredient
}

// MARK: - PantryCollectionViewCell

class PantryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PantryCollectionViewCell"
    weak var delegate: PantryCollectionViewCellDelegate?
    var viewModel: PantryCollectionViewCellViewModel!
    
    var isEditing: Bool = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
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
        label.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.backgroundColor = UIColor.link.withAlphaComponent(0.3)
        button.layer.cornerRadius = 20
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.isHidden = true
        
        return button
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
        self.addSubview(deleteButton)
        
        nameLabel.text = viewModel.ingredient.name
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
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
        deleteButton.snp.makeConstraints { make in
            make.rightMargin.equalTo(self.snp_rightMargin).offset(-10)
            make.topMargin.equalTo(self.snp_topMargin).offset(10)
//            make.width.equalTo(45)
//            make.height.equalTo(45)
            make.leftMargin.equalTo(self.snp_rightMargin).offset(-30)
            make.bottomMargin.equalTo(self.snp_topMargin).offset(30)
        }
    }
    
    // MARK: - UI Action
    
    @objc func deleteButtonTapped() {
        delegate?.deleteCollectionItem(self)
    }
    
    // MARK: - UICollectionViewCell Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
    }
}
