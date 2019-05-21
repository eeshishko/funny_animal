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
    private let redPlane = SCNPlane()
    private(set) var redPlaneYCoordinate: CGFloat = -1.8
    
    init(width: CGFloat = 2, height: CGFloat = 2, redPlaneYCoordinate: CGFloat = -0.8) {
        super.init()
        self.redPlaneYCoordinate = redPlaneYCoordinate
        let image = UIImage(named: "art.scnassets/grass3.jpg")
        let grassMaterial = SCNMaterial()
        grassMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(8, 8, 0)
        grassMaterial.diffuse.wrapS = .repeat
        grassMaterial.diffuse.wrapT = .repeat
        grassMaterial.diffuse.contents = image
        grassMaterial.isDoubleSided = true
        
        plane.materials = [grassMaterial]
        
        plane.width = width
        plane.height = height
        
        geometry = plane
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        setupLight()
        
        setupRedPlane()
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
        light.intensity = 100
        light.color = UIColor.white
        self.light = light
    }
    
    func setupRedPlane() {
        let node = SCNNode()
        node.position = SCNVector3(0,redPlaneYCoordinate,0.00001)
        redPlane.width = plane.width
        redPlane.height = 0.005
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        redPlane.materials = [material]
        node.geometry = redPlane
        addChildNode(node)
    }

}
