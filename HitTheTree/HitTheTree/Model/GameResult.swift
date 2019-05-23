//
//  GameResult.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import Foundation

class GameResult {
	var score: Int = 0
    var date: Date = Date()
	var playerName: String = ""
	
    init(score: Int, date: Date) {
//        let playerName = "none"//UserDefaults.standard.string(forKey: UserDefaultKeys.playerName)!
//        let playerName = ""
//        self.init(score: score, date: date, playerName: playerName)
        
    }

    init(score: Int, playerName: String) {
		self.score = score
//        self.date = date
		self.playerName = playerName
	}

//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(score, forKey: "score")
//        aCoder.encode(date, forKey: "date")
//        aCoder.encode(playerName, forKey: "playerName")
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        let score = aDecoder.decodeInteger(forKey: "score")
//        let date = aDecoder.decodeObject(forKey: "date") as! Date
//        let playerName = aDecoder.decodeObject(forKey: "playerName") as! String
//        self.init(score: score, date: date, playerName: playerName)
//    }
}
