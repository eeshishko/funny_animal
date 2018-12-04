//
//  RulesViewController.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func close(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}
