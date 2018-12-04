//
//  GameResult.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import Foundation

class GameResult: NSObject, NSCoding {
	let score: Int
	let date: Date
	
	init(score: Int, date: Date) {
		self.score = score
		self.date = date
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(score, forKey: "score")
		aCoder.encode(date, forKey: "date")
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		let score = aDecoder.decodeInteger(forKey: "score")
		let date = aDecoder.decodeObject(forKey: "date") as! Date
		self.init(score: score, date: date)
	}
}
