//
//  GameRecordsViewController.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit

class GameRecordsViewController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	var records: [GameResult] = [GameResult]()
	let cellIdentifier = String(describing: GameRecordTableViewCell.self)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let playerName = UserDefaults.standard.string(forKey: UserDefaultKeys.playerName)!
		titleLabel.text = "Рекорды \"\(playerName)\""
		
		setupTableView()
		loadRecords()
	}
	
	private func loadRecords() {
		if let encodedData = UserDefaults.standard.object(forKey: UserDefaultKeys.records) as? Data {
			records = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [GameResult]
			records.sort(by: {$0.score > $1.score})
		}
		tableView.reloadData()
	}
	
	private func setupTableView() {
		tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	// MARK: - Actions
	
	@IBAction func close(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

extension GameRecordsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return records.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier:cellIdentifier, for: indexPath) as! GameRecordTableViewCell
		cell.configure(with: records[indexPath.row])
		return cell
	}
}

extension GameRecordsViewController: UITableViewDelegate {
}
