//
//  GameOverViewController.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit

protocol GameOverViewControllerDelegate: class {
	func didTapMenuButton(viewController: UIViewController)
}

class GameOverViewController: UIViewController {
	weak var delegate: GameOverViewControllerDelegate?
	var score: Int?
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var recordLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scoreLabel.text = "\(score!)"
		
		let records: [GameResult]
		recordLabel.isHidden = true
		if let encodedData = UserDefaults.standard.object(forKey: UserDefaultKeys.records) as? Data {
			records = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [GameResult]
			for rec in records {
				if score! > rec.score {
					recordLabel.isHidden = false
					break
				}
			}
		}
		
		saveResult(score: score!)
	}
	
	func saveResult(score: Int) {
		let gameResult = GameResult(score: score, date: Date())
		var records: [GameResult]
		
		if let encodedData = UserDefaults.standard.object(forKey: UserDefaultKeys.records) as? Data {
			records = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [GameResult]
			records.append(gameResult)
		} else {
			records = [GameResult]()
			records.append(gameResult)
		}
		
		let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: records)
		
		UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.records)
		UserDefaults.standard.synchronize()
	}
	@IBAction func callMenuBlock(_ sender: Any) {
		dismiss(animated: true) { [weak self] in
			guard let `self` = self else {
				return
			}
			self.delegate?.didTapMenuButton(viewController: self)
		}
	}
}
