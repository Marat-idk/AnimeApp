//
//  UIViewController+Alert.swift
//  AnimeApp
//
//  Created by Марат on 03.09.2023.
//

import UIKit

// MARK: - UIViewController+Alert
extension UIViewController {
    func showAlert(title: String,
                   message: String? = nil,
                   showCancel: Bool = false,
                   cancelButtonTitle: String = "Cancel",
                   firstButtonTitle: String = "OK",
                   secondButtonTitle: String? = nil,
                   firstCompletion: (() -> Void)? = nil,
                   secondCompletion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstButtonAction = UIAlertAction(title: firstButtonTitle, style: .default) { _ in
            firstCompletion?()
        }
        
        alert.addAction(firstButtonAction)
        
        if let secondButtonTitle = secondButtonTitle {
            let secondButtonAction = UIAlertAction(title: secondButtonTitle, style: .default) { _ in
                secondCompletion?()
            }
            
            alert.addAction(secondButtonAction)
        }
        
        if showCancel {
            let cancelButtonAction = UIAlertAction(title: cancelButtonTitle, style: .cancel)
            
            alert.addAction(cancelButtonAction)
        }
        
        present(alert, animated: true)
    }
}
