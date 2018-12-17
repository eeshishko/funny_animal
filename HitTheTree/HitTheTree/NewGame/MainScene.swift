//
//  MainScene.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 08/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit
import AudioToolbox.AudioServices

class MainScene: SCNNode {
    
    let floor = SCNFloor()
    let floorNode = SCNNode()
    
    let rockManager = RockManager()
    var cloudsManager: NewCloudsManager!

    override init() {
        super.init()
        setupFloor()
        setupLight()
        addRock()
        cloudsManager = NewCloudsManager(node: self, worldWidth: Float(floor.width), worldLength: Float(floor.length))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapLocation(hitTests: [SCNHitTestResult], pointOfView: SCNNode, shootPoint: SCNVector3 = SCNVector3(0, -1, 0)) {
        if let firstHitTest = hitTests.filter({$0.node.name == "floor"}).first {
            let node = firstHitTest.node
            var pos = convertPosition(firstHitTest.localCoordinates, from: node)
            pos.z = 0
            //pos.x += Float.random(in: -0.3...0.3)
            //pos.y += Float.random(in: -0.3...0.3)
            
//            let position1 = convertPosition(shootPoint, from: pointOfView)
//            var direction1 = SCNVector3((pos.x - position1.x) * 1.0, (pos.y - position1.y) * 1.0, (pos.z - position1.z) * 1.0)
            
            
            var shootP = pointOfView.convertPosition(shootPoint, from: nil)
            let position1 = convertPosition(shootP, from: pointOfView)
            var direction1 = SCNVector3((pos.x - position1.x) * 1.0, (pos.y - position1.y) * 1.0, (pos.z - position1.z) * 1.0)

            
            direction1 = convertVector(direction1, to: nil)
            print("position: \(position1)  direction: \(direction1)")
            shoot(position: position1, direction: direction1)
        }
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
        
        floorNode.name = "floor"
        floorNode.position = SCNVector3(0,0,0)
        floorNode.eulerAngles = SCNVector3(-CGFloat.pi/2,0,0)
        eulerAngles = SCNVector3(-CGFloat.pi/2,0,0)
        //transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        floorNode.geometry = floor
        addChildNode(floorNode)
    }
    
    fileprivate func setupLight() {
        let itencityScale: CGFloat = 1.0
        let ambientNode = SCNNode()
        let light = SCNLight()
        light.intensity = 300 * itencityScale
        light.color = UIColor(white: 0.75, alpha: 1.0)
        light.type = .ambient
        ambientNode.light = light
        addChildNode(ambientNode)

        
        let frontDirNode = SCNNode()
        let front1 = SCNLight()
        front1.intensity = 1700 * itencityScale
        front1.color = UIColor(white: 0.5, alpha: 1.0)
        front1.type = .directional
        frontDirNode.light = front1
        frontDirNode.position = SCNVector3(floor.length * 1.2,0,1)
        frontDirNode.eulerAngles = SCNVector3(CGFloat.pi/4, CGFloat.pi/4, 0)
        addChildNode(frontDirNode)
        
        
        let frontDirNode2 = SCNNode()
        let front2 = SCNLight()
        front2.intensity = 1100 * itencityScale
        front2.color = UIColor(white: 0.5, alpha: 1.0)
        front2.type = .directional
        frontDirNode2.light = front2
        frontDirNode2.position = SCNVector3(-floor.length * 1.2,0,1)
        frontDirNode2.eulerAngles = SCNVector3(CGFloat.pi/2,0,0)
        addChildNode(frontDirNode2)
        
        
        let cloudeTopLightNode = SCNNode()
        let cloudeTopLight = SCNLight()
        cloudeTopLight.intensity = 1000 * itencityScale
        cloudeTopLight.color = UIColor(red: 63.0/255.0, green: 167.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        cloudeTopLight.categoryBitMask = 4
        cloudeTopLight.type = .directional
        cloudeTopLightNode.light = cloudeTopLight
        cloudeTopLightNode.position = SCNVector3(0,0,0)
        cloudeTopLightNode.eulerAngles = SCNVector3(0,0,0)
        addChildNode(cloudeTopLightNode)
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
    
    fileprivate func addRock() {
        let rock1 = RockManager.createRock1()
        rock1.position = SCNVector3(0,0,0)
        addChildNode(rock1)
    }
    
    
    private func shoot(position: SCNVector3, direction: SCNVector3) {
        let arBullet = ARBullet()
        
        arBullet.position = position
        arBullet.initialPosition = position
        
        let bulletDirection = direction
        arBullet.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        addChildNode(arBullet)
        
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
        
        //soundManager.playShootSound(node: sceneView.scene.rootNode)
    }
    
    
}
