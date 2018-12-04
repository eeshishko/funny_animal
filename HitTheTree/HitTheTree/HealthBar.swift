//
//  HealthBar.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

private let kWidth: CGFloat = 0.05

class HealthBar: SCNNode {
    
    let plane = SCNPlane(width: kWidth, height: 0.008)
    let planeNode = SCNNode()

    var health: CGFloat = 1.0 {//from 0 to 1
        didSet {
            let delta = kWidth * (1.0 - health)/2
            plane.width = kWidth * health
            planeNode.position = SCNVector3(-delta,0,0)
            
            let material = SCNMaterial()

            if health > 0.3 && health < 0.7 {
                material.diffuse.contents = UIColor.yellow
                plane.materials = [material]
            } else if health < 0.3 {
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.red
                plane.materials = [material]
            } else {
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.green
                plane.materials = [material]
            }
        }
    }
    
    override init() {
        super.init()
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        plane.materials = [material]
        
        
        planeNode.geometry = plane
        planeNode.position = SCNVector3(0,0,0)
        addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
