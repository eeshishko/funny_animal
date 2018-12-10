//
//  LeaderBoardManager.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 10/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import FirebaseDatabase

class LeaderBoardManager: NSObject {
    
    let vendorId = UIDevice.current.identifierForVendor?.uuidString ?? "dev_user"
    
    static let manager = LeaderBoardManager()
    
    private let ref = Database.database().reference()
    
    func update(playerName: String, completion: @escaping (Error?) -> Void ) {
        if vendorId.count > 0 {
            self.ref.child("users").child(vendorId).setValue(["username":playerName]) { (error:Error?, ref:DatabaseReference) in
               //
                if let error = error {
                    print("Data could not be saved: \(error).")
                    completion(error)
                } else {
                    print("Data saved successfully!")
                }
            }
//            {
//                (error:Error?, ref:DatabaseReference) in
//                completion?(error)
//            }
//            self.ref.child("users").child(vendorId).setValue(["username":playerName]) {
//                (error:Error?, ref:DatabaseReference) in
//                completion?(error)
//            }
        }
    }
    
    func addResult(playerName: String, result: Int, completion: ((Error?) -> Void)?) {
        if vendorId.count > 0 {
            self.ref.child("users").child(vendorId).setValue(["username":playerName]) {
                (error:Error?, ref:DatabaseReference) in
                completion?(error)
            }
        }
    }
    
    func getResults(playerName: String, completion: (([GameResult], Error?) -> Void)?) {
        
    }
    

}
