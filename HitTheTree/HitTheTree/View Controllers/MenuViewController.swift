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
		
		let gameResult = GameResult(score: 50, date: Date())
		let array: [GameResult] = Array(repeating: gameResult, count: 40)
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: array)
		
		UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.records)
		UserDefaults.standard.synchronize()
	}
}
