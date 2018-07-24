//
//  Extensions.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    ///Dissmiss the keyboard when user tab around the textfield
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    ///End editing of the view(textfield in this case)
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
