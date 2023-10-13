//
//  UIAlertController+.swift
//  pantry-app
//
//  Created by Marco Agizza on 13/10/23.
//

import UIKit

extension UIAlertController {
    static func buildOkAlert(title: String, message: String, displayAlert: @escaping(UIAlertController) -> Void) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in}))
        
        displayAlert(alertController)
    }
}
