//
//  DataManagerProtocol.swift
//  HitTheTree
//
//  Created by Evgeny Shishko on 14/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import Foundation

protocol DataManager {
	func save(_ result: GameResult)
	func fetchResults() -> [GameResult]
}
