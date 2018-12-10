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

        // Do any additional setup after loading the view.
    }
    
	@IBAction func saveName(_ sender: Any) {
		guard let textFieldValue = nameTextField.text else {
			let alert = UIAlertController(title: "Ошибка", message: "Введите корректное имя", preferredStyle: .alert)
			present(alert, animated: true, completion: nil)
			return
		}
		
		guard !textFieldValue.isEmpty && !textFieldValue.trimmingCharacters(in: .whitespaces).isEmpty else {
			let alert = UIAlertController(title: "Ошибка", message: "Введите корректное имя", preferredStyle: .alert)
			present(alert, animated: true, completion: nil)
			return
		}
		
		let userDefaults = UserDefaults.standard
		userDefaults.set(textFieldValue, forKey: UserDefaultKeys.playerName)
		userDefaults.synchronize()
		
		dismiss(animated: true, completion: nil)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
