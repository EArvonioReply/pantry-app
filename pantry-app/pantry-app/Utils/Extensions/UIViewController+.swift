//
//  UIViewController+.swift
//  pantry-app
//
//  Created by Marco Agizza on 13/10/23.
//

import UIKit

extension UIViewController {
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        
        return toolbar
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}
