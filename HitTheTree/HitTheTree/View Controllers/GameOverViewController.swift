//
//  GameOverViewController.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit
import Firebase

protocol GameOverViewControllerDelegate: class {
	func didTapMenuButton(viewController: UIViewController)
}

class GameOverViewController: UIViewController {
	var gameResult = GameResult(score: 0, date: Date())
    var gameDuration: Int = 0
	weak var delegate: GameOverViewControllerDelegate?
	
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var recordLabel: UILabel!
	@IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        menuButton.isEnabled = false
		scoreLabel.text = "\(gameResult.score)"
//        gameOverLabel.text = "Время вышло, \(gameResult.playerName)"
//        let records: [GameResult]
		recordLabel.isHidden = true

//        menuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callMenuBlock(_:))))


        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateInitialViewController()!
            self.present(vc, animated: true, completion: nil)
        }

        let username = MenuViewController.user ?? ""
        AppDelegate.ref.child("scores/\(username)").setValue(gameResult.score)

//        if let encodedData = UserDefaults.standard.object(forKey: UserDefaultKeys.records) as? Data {
//            records = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [GameResult]
//            for rec in records {
//                if gameResult!.score > rec.score {
//                    recordLabel.isHidden = false
//                    break
//                }
//            }
//        }
        
//        LeaderBoardManager.manager.getResults {[weak self] (results, error) in
//            guard let `self` = self else {
//                return
//            }
//            for rec in results {
//                if self.gameResult.score > rec.score {
//                    self.recordLabel.isHidden = false
//                    break
//                }
//            }
//        }
//        saveResult()
	}
	
//    func saveResult() {
//        LeaderBoardManager.manager.addResult(result: gameResult.score) {[weak self] (error) in
//            if let _ = error {
//                self?.showServerErrorAlert()
//            } else {
//                self?.menuButton.isEnabled = true
//            }
//        }

//        var records: [GameResult]

//        if let encodedData = UserDefaults.standard.object(forKey: UserDefaultKeys.records) as? Data {
//            records = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [GameResult]
//            records.append(gameResult!)
//        } else {
//            records = [GameResult]()
//            records.append(gameResult!)
//        }
//
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: records)
//
//        UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.records)
//        UserDefaults.standard.synchronize()
//    }

//    func showServerErrorAlert() {
//        let alert = UIAlertController(title: "Ошибка", message: "Что-то на сервере пошло не так. Повторите отправку!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default) {[weak self] (action) in
//            self?.saveResult()
//        })
//        present(alert, animated: true, completion: nil)
//    }

    
	@IBAction func callMenuBlock(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateInitialViewController()!
        present(vc, animated: true, completion: nil)
//        dismiss(animated: true) { [weak self] in
//            guard let `self` = self else {
//                return
//            }
//            self.delegate?.didTapMenuButton(viewController: self)
//        }
	}
}
