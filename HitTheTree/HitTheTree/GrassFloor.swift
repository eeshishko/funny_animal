//
//  GrassFloor.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit
import ARKit

class GrassFloor: SCNNode {
    
    let plane = SCNPlane()
    
    override init() {
        super.init()
        let image = UIImage(named: "art.scnassets/grass2.png")
        let grassMaterial = SCNMaterial()
        //grassMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(32, 32, 0)
        grassMaterial.diffuse.contents = image
        grassMaterial.isDoubleSided = true
        
        plane.materials = [grassMaterial]
        
        geometry = plane
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        setupLight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(planeAnchor: ARPlaneAnchor) {
        position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        plane.width = 1//CGFloat(planeAnchor.extent.x)
        plane.height = 1//CGFloat(planeAnchor.extent.z)
    }
    
    func setupLight() {
        let light = SCNLight()
        light.type = .ambient
        light.intensity = 1000
        light.color = UIColor.white
        self.light = light
    }

}
