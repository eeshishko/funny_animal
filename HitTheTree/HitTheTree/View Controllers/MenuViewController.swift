//
//  MenuViewController.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
		
		checkIfNameExists()
	}
	
	private func checkIfNameExists() {
		if let _ = UserDefaults.standard.string(forKey: UserDefaultKeys.playerName) {
			return
		} else {
			changeName(self)
		}
	}
	@IBAction func changeName(_ sender: Any) {
		performSegue(withIdentifier: "showChangeName", sender: nil)
	}
}
