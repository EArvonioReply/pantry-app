//
//  ViewController.swift
//  pantry-app
//
//  Created by Marco Agizza on 25/09/23.
//

import UIKit
import SnapKit
import MVVMKit

// MARK: - PantryViewControllerDelegate

protocol PantryViewControllerDelegate: AnyObject {
    func pantryViewControllerDidPush(_ ingredient: Ingredient)
    func pantryViewControllerDidPresent()
}

// MARK: - PantryViewController

class PantryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: PantryViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var viewModel: PantryViewControllerViewModel
    
    // MARK: - PantryViewController Init Methods
    
    init(viewModel: PantryViewControllerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.loadData { [weak self] in
            self?.ingredientsCollectionView.reloadData()
            
        }
        title = "Pantry"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let ingredientsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PantryCollectionViewCell.self, forCellWithReuseIdentifier: PantryCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return collectionView
    }()
    
    // MARK: - UIViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.checkForPermission() { alertController in
            self.present(alertController, animated: true)
        }
        setupUI()
        
        ingredientsCollectionView.dataSource = self
        ingredientsCollectionView.delegate = self
        
    }

    private func setupUI() {
        view.addSubview(ingredientsCollectionView)
        ingredientsCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(didTapPlusButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEditButton))
    }
    
    // MARK: - UI Action
    
    @objc private func didTapPlusButton() {
        delegate?.pantryViewControllerDidPresent()
    }
    
    @objc private func didTapEditButton(_ sender: UIBarButtonItem) {
        setEditing(!isEditing, animated: true)
        if isEditing {
            sender.title = "Done"
        } else {
            sender.title = "Edit"
        }
        ingredientsCollectionView.indexPathsForVisibleItems.forEach { indexPath in
            let cell = ingredientsCollectionView.cellForItem(at: indexPath) as! PantryCollectionViewCell
            cell.isEditing = isEditing
        }
    }
    
    func add(new ingredient: Ingredient) {
        viewModel.add(new: ingredient, updateCollection: {
            DispatchQueue.main.async { self.ingredientsCollectionView.reloadData() }
        }) { (dayBeforeExpiringDate, hour, minute) in
            let alertController = UIAlertController(title: "Notification Scheduled", message: "You will be reminded of the product expiration on \(dayBeforeExpiringDate) at \(hour):\(minute)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok, thanks!", style: .default, handler: { (_) in}))
            self.present(alertController, animated: true)
        }
    }

}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource Extension

extension PantryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfIngredients
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PantryCollectionViewCell.identifier, for: indexPath) as? PantryCollectionViewCell else {
            fatalError("Failed to dequeue CustomCollectionViewCell in CollectionViewController")
        }
        
        cell.configure(by: PantryCollectionViewCellViewModel(ingredient: viewModel.getIngredient(at: indexPath.row)))
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pantryViewControllerDidPush(viewModel.getIngredient(at: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extension

extension PantryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Size: subtract (HorizontalSpacing*Separators)/NumberOfItems + collection view offset: (2*1)/2
        let size = (view.frame.width/2) - 1.5 - 8.8
        return CGSize(width: size, height: size + (size/3))
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

extension PantryViewController: PantryCollectionViewCellDelegate {
    func deleteCollectionItem(_ pantryCollectionViewCell: PantryCollectionViewCell) {
        guard let indexPath = ingredientsCollectionView.indexPath(for: pantryCollectionViewCell) else { return }
        viewModel.removeIngredient(at: indexPath.row) {
            self.ingredientsCollectionView.reloadData()
        }
    }
}
