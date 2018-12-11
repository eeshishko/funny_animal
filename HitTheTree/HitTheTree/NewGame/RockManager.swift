//
//  RockManager.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 08/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class RockManager: NSObject {

    override init() {
        
    }
    
    static func createRock1() -> SCNNode {
        let scene = SCNScene(named: "art.scnassets/rock1.scn")
        let node = scene?.rootNode.childNode(withName: "rock", recursively: false) ?? SCNNode()
        return node
    }
    
}
