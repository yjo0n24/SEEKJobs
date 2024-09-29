//
//  KeyboardToolbar.swift
//  SEEKJobs
//
//  Created by Yew Joon Wong on 28/09/2024.
//

import Foundation
import UIKit

class KeyboardToolbar: UIToolbar {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.barStyle = .default
        self.isTranslucent = true
        self.tintColor = .systemBlue

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDoneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.items = [spaceButton, doneButton]

        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }

    @objc private func btnDoneAction() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
