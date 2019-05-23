//
//  GameRecordTableViewCell.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit

class GameRecordTableViewCell: UITableViewCell {
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func configure(with gameResult: GameResult) {
        scoreLabel.text = "\(gameResult.score) (\(gameResult.playerName))"
        dateLabel.isHidden = true
//        dateLabel.text = "\(gameResult.playerName)"
	}
}
