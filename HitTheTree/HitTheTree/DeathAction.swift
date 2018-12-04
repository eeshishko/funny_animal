//
//  DeathAction.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 05/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class DeathAction: NSObject {

    static func deathAction(height: Float, duration: TimeInterval) -> SCNAction {
        let startVelocity = height/Float(duration/2.0) - kGravity.z * Float(duration/2.0)/2
        let action = SCNAction.customAction(duration: duration) { (node, currentTime) in
            var position = node.position
            position.z = startVelocity * Float(currentTime) + kGravity.z * Float(currentTime * currentTime)/2.0
            node.position = position
        }
        return action
    }
    
}
