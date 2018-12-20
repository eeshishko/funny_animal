//
//  Ghost.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class Ghost: SCNNode {

    fileprivate(set) var box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
    
    init(box: SCNBox = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)) {
        super.init()
        box.materials = materials()
        let cubeNode = SCNNode(geometry: box)
        cubeNode.position = SCNVector3(x: 0, y: 0, z: 0)
        addChildNode(cubeNode)
        self.opacity = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func materials() -> [SCNMaterial] {
        let material1 = SCNMaterial()
        material1.diffuse.contents = UIImage(named: "art.scnassets/ghost/Ghost.png")
        material1.locksAmbientWithDiffuse = true
        
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIImage(named: "art.scnassets/ghost/Ghost2.png")
        material2.locksAmbientWithDiffuse = true
        
        return [material1, material2, material2, material2, material2, material2]
    }
    
}
