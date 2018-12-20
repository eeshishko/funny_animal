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
	}
	
	override func viewDidAppear(_ animated: Bool) {
		checkIfNameExists()
	}
	
	private func checkIfNameExists() {
		if let _ = UserDefaults.standard.string(forKey: UserDefaultKeys.playerName) {
			return
		} else {
			performSegue(withIdentifier: "showChangeName", sender: nil)
		}
	}
	@IBAction func changeName(_ sender: Any) {
		performSegue(withIdentifier: "showChangeName", sender: nil)
	}
}
