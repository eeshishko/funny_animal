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
    var timer: Timer?
	override func viewDidLoad() {
		super.viewDidLoad()

		titleLabel.text = "Статистика"

//        AppDelegate.ref.child("scores/\(username)").setValue(gameResult.score)

        tableView.tableFooterView = UIView()
		
		setupTableView()
        load()

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(load), userInfo: nil, repeats: true)

//        loadRecords()
	}

    @objc func load() {
        AppDelegate.ref.child("scores").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary

            self.records.removeAll()

            for (k,v) in value {
                self.records.append(GameResult(score: v as! Int, playerName: k as! String))
            }

            self.records.sort(by: { (f, s) -> Bool in
                f.score > s.score
            })

            //            self.tableView.reloadData()
            self.tableView.reloadSections(IndexSet([0]), with: .automatic)

        }) { (error) in
            print(error.localizedDescription)
        }
    }
	
	private func loadRecords() {
        LeaderBoardManager.manager.getResults {[weak self] (results, error) in
            self?.records = results.filter({$0.score > 0}).sorted(by: {$0.score > $1.score})
            self?.tableView.reloadData()
        }
//        if let encodedData = UserDefaults.standard.object(forKey: UserDefaultKeys.records) as? Data {
//            records = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [GameResult]
//            records.sort(by: {$0.score > $1.score})
//        }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
