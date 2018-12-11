//
//  NewCloudsManager.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 08/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class NewCloudsManager: NSObject {

    struct Cloud {
        var node: SCNNode = SCNNode()
        var velocity: CGFloat = 0
    }
    
    let rootNode: SCNNode
    let worldWidth: Float
    let worldLength: Float
    var timer: Timer!
    var clouds: [Cloud] = []
    var yCoordinates: [CGFloat] = []
    
    let maxCloudsCount = 5
    
    init(node: SCNNode, worldWidth: Float = 1.0, worldLength: Float = 1.0) {
        rootNode = node
        self.worldWidth = worldWidth
        self.worldLength = worldLength
        super.init()
        setupYCoordinates()
        timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(CloudsManager.updateClouds), userInfo: nil, repeats: true)
    }
    
    func setupYCoordinates() {
        yCoordinates.removeAll()
        let start: CGFloat = CGFloat(-worldLength)/2.0
        let coordinatesCount = 4
        let space: CGFloat = CGFloat(worldLength)/CGFloat(coordinatesCount)
        for i in 0...coordinatesCount {
            yCoordinates.append(CGFloat(i) * space + start)
        }
    }
    
    func createCloud() {
        let rand = Int.random(in: 1...1)
        let scene = SCNScene(named: "art.scnassets/cloud\(rand).scn")
        let cloud1 = scene?.rootNode.childNode(withName: "cloud", recursively: false) ?? SCNNode()
        cloud1.categoryBitMask = 3
        
        let randPos = randomPositions()
        cloud1.position = randPos.position
        cloud1.eulerAngles = SCNVector3(0,0,CGFloat.pi/2)
        rootNode.addChildNode(cloud1)
        
        var cl = Cloud()
        cl.node = cloud1
        cl.velocity = randPos.velocity
        clouds.append(cl)
    }
    
    @objc func updateClouds() {
        
        if clouds.count < maxCloudsCount {
            createCloud()
        }
        
        for cloud in clouds {
            var pos = cloud.node.position
            pos.x += Float(cloud.velocity)
            cloud.node.position = pos
            
            let f = fabsf(pos.x) - fabsf(worldWidth/2.0)
            var opacity = f / 0.2
            if opacity > 0 && opacity < 1 {
                opacity = 1 - opacity
            } else if opacity > 1 {
                opacity = 0.0
                cloud.node.removeFromParentNode()
            } else if opacity < 0 {
                opacity = 1.0
            }
            cloud.node.opacity = CGFloat(opacity)
        }
        
        clouds = clouds.filter({$0.node.parent != nil})
        
    }
    
    func randomPositions() -> (position: SCNVector3, velocity: CGFloat) {
        var tuple : (position: SCNVector3, velocity: CGFloat) = (position: SCNVector3(0,0,0), velocity: 0)
        var flag: Bool = true
        while flag {
            var randomX : CGFloat = 0
            if Int.random(in: 0...1) == 0 {
                randomX = CGFloat(worldWidth/2.0 + 0.2)
            } else {
                randomX = -(CGFloat(worldWidth/2.0 + 0.2))
            }
            let randomYValue = Int.random(in: 0..<yCoordinates.count)
            let z: CGFloat = 0.5
            
            tuple.velocity = CGFloat.random(in: 0.0005...0.002)
            if randomX > 0 {
                tuple.velocity *= -1
            }
            
            tuple.position = SCNVector3(randomX, yCoordinates[randomYValue], z)
            flag = false
            for cloud in clouds {
                if tuple.position.y == cloud.node.position.y {
                    flag = true
                    break
                }
            }
        }
        return tuple
    }
    
    
}
