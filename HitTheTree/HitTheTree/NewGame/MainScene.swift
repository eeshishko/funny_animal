//
//  MainScene.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 08/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class MainScene: SCNNode {
    
    let floor = SCNFloor()
    let floorNode = SCNNode()

    override init() {
        super.init()
        setupFloor()
        setupLight()
        addCube()
    }
    
    fileprivate func setupFloor() {
        floor.width = 2
        floor.length = 2
        floor.reflectivity = 0.0
        
        let mat = SCNMaterial()
        mat.lightingModel = .lambert
        mat.diffuse.contents = UIColor(red: 144.0/255.0, green: 180.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        mat.isDoubleSided = true
        
        floor.materials = [mat]
        
        floorNode.position = SCNVector3(0,0,0)
        floorNode.eulerAngles = SCNVector3(-CGFloat.pi/2,0,0)
        eulerAngles = SCNVector3(-CGFloat.pi/2,0,0)
        //transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        floorNode.geometry = floor
        addChildNode(floorNode)
    }
    
    fileprivate func setupLight() {
        let ambientNode = SCNNode()
        let light = SCNLight()
        light.intensity = 300
        light.color = UIColor(white: 0.75, alpha: 1.0)
        light.type = .ambient
        ambientNode.light = light
        addChildNode(ambientNode)

        
        let frontDirNode = SCNNode()
        let front1 = SCNLight()
        front1.intensity = 2000
        front1.color = UIColor(white: 0.5, alpha: 1.0)
        front1.type = .directional
        frontDirNode.light = front1
        frontDirNode.position = SCNVector3(floor.length * 1.2,0,1)
        frontDirNode.eulerAngles = SCNVector3(CGFloat.pi/4, CGFloat.pi/4, 0)
        addChildNode(frontDirNode)
        
        
        let frontDirNode2 = SCNNode()
        let front2 = SCNLight()
        front2.intensity = 1200
        front2.color = UIColor(white: 0.5, alpha: 1.0)
        front2.type = .directional
        frontDirNode2.light = front2
        frontDirNode2.position = SCNVector3(-floor.length * 1.2,0,1)
        frontDirNode2.eulerAngles = SCNVector3(-CGFloat.pi/4,-CGFloat.pi/4,0)
        addChildNode(frontDirNode2)
    }
    
    fileprivate func addCube() {
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let mat = SCNMaterial()
        mat.lightingModel = .lambert
        mat.diffuse.contents = UIColor.white
        box.materials = [mat]
        let node = SCNNode()
        node.geometry = box
        node.position = SCNVector3(0,0,3)
        addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
