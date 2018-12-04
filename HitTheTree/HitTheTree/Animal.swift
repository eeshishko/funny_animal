//
//  Animal.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class Animal: SCNNode {

    var velocity : SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    fileprivate var maxHealth: CGFloat = 5.0
    fileprivate var health: CGFloat = 5.0 {
        didSet {
            healthBar.health = health/maxHealth
        }
    }
    private let healthBar = HealthBar()
    fileprivate(set) var isAlive = true
    fileprivate let ghost = Ghost()
    
    fileprivate(set) var box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
    
    override init() {
        super.init()
        
        let cubeNode = SCNNode(geometry: box)
        cubeNode.position = SCNVector3(x: 0, y: 0, z: 0)
        addChildNode(cubeNode)
        
        addChildNode(healthBar)
        healthBar.position = SCNVector3(0,box.width,0)
        
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = CollisionCategory.logos.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.arBullets.rawValue
        
    }
    
    func damage(value: CGFloat) {
        var health = self.health - value
        if health < 0 {
            health = 0
            killAnimal()
        } else {
            
        }
        self.health = health
    }
    
    func killAnimal() {
        guard isAlive else {
            return
        }
        print("kill")
        isAlive = false
        ghost.position = position
        
        parent?.addChildNode(ghost)
        var toPosition = self.position
        toPosition.z += 0.3
        let duration : TimeInterval = 3.0
        let moveAction = SCNAction.move(to: toPosition, duration: duration)
        let fadeOuttAction = SCNAction.fadeOut(duration: duration)
        let removeAction = SCNAction.removeFromParentNode()
        let sequence = SCNAction.group([moveAction,fadeOuttAction])
        let totalAction = SCNAction.sequence([sequence,removeAction])
        ghost.runAction(totalAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
