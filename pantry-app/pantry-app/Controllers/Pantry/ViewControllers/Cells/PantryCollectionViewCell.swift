//
//  PantryCollectionViewCell.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit
import SnapKit

class PantryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PantryCollectionViewCell"
    
    // MARK: - UI Components
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = .systemOrange
        imageView.clipsToBounds = true
        imageView.layer.borderColor = CGColor(red: 255, green: 123, blue: 23, alpha: 1)
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    // MARK: - PantryCollectionViewCell Configuration Methods
    
    public func configure(with image: UIImage) {
        myImageView.image = image
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        myImageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: - UICollectionViewCell Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
    }
}
