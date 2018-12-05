//
//  GameOverViewController.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var recordLabel: UILabel!
	
	var menuClickHandler: (() -> (Void))?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let score = Int(scoreLabel.text!)!
		let records: [GameResult]
		recordLabel.isHidden = true
		if let encodedData = UserDefaults.standard.object(forKey: UserDefaultKeys.records) as? Data {
			records = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [GameResult]
			for rec in records {
				if score > rec.score {
					recordLabel.isHidden = false
					break
				}
			}
		}
	}
	@IBAction func callMenuBlock(_ sender: Any) {
		menuClickHandler?()
	}
}
