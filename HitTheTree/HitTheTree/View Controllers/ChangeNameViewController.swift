//
//  ChangeNameViewController.swift
//  HitTheTree
//
//  Created by Evgeny Shishko on 10/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit

class ChangeNameViewController: UIViewController {
	@IBOutlet weak var nameTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		nameTextField.delegate = self
		if let textFieldValue = UserDefaults.standard.string(forKey: UserDefaultKeys.playerName) {
			nameTextField.text = textFieldValue
		}
    }
    
	@IBAction func saveName(_ sender: Any) {
		guard let textFieldValue = nameTextField.text else {
			let alert = UIAlertController(title: "Ошибка", message: "Введите корректное имя", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
		
		guard !textFieldValue.isEmpty && !textFieldValue.trimmingCharacters(in: .whitespaces).isEmpty else {
			let alert = UIAlertController(title: "Ошибка", message: "Введите корректное имя", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
		
		let userDefaults = UserDefaults.standard
		userDefaults.set(textFieldValue, forKey: UserDefaultKeys.playerName)
		userDefaults.synchronize()
		
		dismiss(animated: true, completion: nil)
	}
}

extension ChangeNameViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		saveName(textField)
		
		return true
	}
}
