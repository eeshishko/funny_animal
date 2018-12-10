//
//  RateGameViewController.swift
//  HitTheTree
//
//  Created by Evgeny Shishko on 10/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import Cosmos

class RateGameViewController: UIViewController {
	@IBOutlet weak var cosmosView: CosmosView!
	
	var rateCompletionHandler: ((Int) -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cosmosView.didFinishTouchingCosmos = {[weak self] rating in
			guard let `self` = self else {
				return
			}
			let rateInt = Int(rating)
			let alert = UIAlertController(title: "Готово", message: "Спасибо, что проголосовали!", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] action in
				guard let `self` = self else {
					return
				}
				self.rateCompletionHandler?(rateInt)
				self.dismiss(animated: true, completion: nil)
			})
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	@IBAction func close(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
}
