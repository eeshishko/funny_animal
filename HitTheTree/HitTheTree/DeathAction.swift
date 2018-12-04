//
//  DeathAction.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 05/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class DeathAction: NSObject {

    static func deathAction(startVelocity: Float, duration: TimeInterval) -> SCNAction {
        let velocity = startVelocity + kGravity.z * Float(duration)/2 //height/Float(duration/2.0)
        let action = SCNAction.customAction(duration: duration) { (node, currentTime) in
            var position = node.position
            position.z = velocity * Float(currentTime) + kGravity.z * Float(currentTime * currentTime)/2.0
            node.position = position
            print("position.z \(position.z)")
        }
        return action
    }
    
}
