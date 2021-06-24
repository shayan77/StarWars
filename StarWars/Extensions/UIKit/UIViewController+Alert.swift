//
//  UIViewController+Alert.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit

extension UIViewController {
    func showAlertWith(_ message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
