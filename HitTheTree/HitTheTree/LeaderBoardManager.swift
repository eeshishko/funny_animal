//
//  LeaderBoardManager.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 10/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import Parse

class LeaderBoardManager: NSObject {
    
    static let manager = LeaderBoardManager()
    
    let vendorId = UIDevice.current.identifierForVendor?.uuidString ?? "dev_user"
    var timer: Timer!
    
    override init() {
        super.init()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {[weak self] (timer) in
            self?.sendLaunchCount()
        })
    }
    
    func update(playerName: String, completion: ((Error?) -> Void)? ) {
        if vendorId.count > 0 {
            let query = PFQuery(className:"Game_User")
            query.whereKey("guid", equalTo:vendorId)
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    
                    if objects.count == 0 {
                        //create user
                        let gameScore = PFObject(className:"Game_User")
                        gameScore["username"] = playerName
                        gameScore["guid"] = self.vendorId
                        gameScore["game_score_1"] = 0
                        gameScore["game_score_2"] = 0
                        gameScore["game_score_3"] = 0
                        gameScore["game_score_4"] = 0
                        gameScore["game_score_5"] = 0
                        gameScore.saveInBackground {
                            (success: Bool, error: Error?) in
                            completion?(error)
                        }
                    } else {
                        for gameScore in objects {
                            gameScore["username"] = playerName
                            gameScore.saveInBackground {
                                (success: Bool, error: Error?) in
                                completion?(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addResult(result: Int, completion: ((Error?) -> Void)?) {
        if vendorId.count > 0 {
            let query = PFQuery(className:"Game_User")
            query.whereKey("guid", equalTo:vendorId)
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    
                    for gameScore in objects {
                        var scores: [Int] = []
                        if let score = gameScore["game_score_1"] as? Int {
                            scores.append(score)
                        }
                        if let score = gameScore["game_score_2"] as? Int {
                            scores.append(score)
                        }
                        if let score = gameScore["game_score_3"] as? Int {
                            scores.append(score)
                        }
                        if let score = gameScore["game_score_4"] as? Int {
                            scores.append(score)
                        }
                        if let score = gameScore["game_score_5"] as? Int {
                            scores.append(score)
                        }
                        scores.append(result)
                        scores.sort()
                        scores.reverse()
                        for i in 0..<min(scores.count, 5) {
                            gameScore["game_score_\(i+1)"] = scores[i]
                        }
                        
                        gameScore.saveInBackground {
                            (success: Bool, error: Error?) in
                            completion?(error)
                        }
                    }
                }
            }
        }
    }
    
    func getResults(сompletion: (([GameResult], Error?) -> Void)?) {
        if vendorId.count > 0 {
            let query = PFQuery(className:"Game_User")
            query.whereKey("guid", equalTo:vendorId)
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    
                    for gameScore in objects {
                        var results: [GameResult] = []
                        for i in 0..<5 {
                            if let score = gameScore["game_score_\(i+1)"] as? Int, score > 0 {
                                let result = GameResult(score: score, date: Date())
                                results.append(result)
                            }
                        }
                        сompletion?(results, error)
                    }
                }
            }
        }
    }
    
    func launchApp() {
        let userDefaults = UserDefaults.standard
        var launchCount = userDefaults.integer(forKey: UserDefaultKeys.launchCount)
        launchCount += 1
        userDefaults.set(launchCount, forKey: UserDefaultKeys.launchCount)
        userDefaults.synchronize()
        if launchCount < 1 {
            return
        }
        
        
        
    }
    
    fileprivate func sendLaunchCount() {
        let userDefaults = UserDefaults.standard
        let launchCount = userDefaults.integer(forKey: UserDefaultKeys.launchCount)
        if launchCount < 1 {
            return
        }
        
        let query = PFQuery(className:"Game_User")
        query.whereKey("guid", equalTo:vendorId)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                let laucnhCountKey = "launch_count"
                for gameScore in objects {
                    let count = (gameScore[laucnhCountKey] as? Int) ?? 0
                    gameScore[laucnhCountKey] = launchCount + count
                    gameScore.saveInBackground {
                        (success: Bool, error: Error?) in
                        if success {
                            userDefaults.set(0, forKey: UserDefaultKeys.launchCount)
                        } else {
                            userDefaults.set(launchCount, forKey: UserDefaultKeys.launchCount)
                        }
                        userDefaults.synchronize()
                    }
                }
            }
        }
    }
    

}
