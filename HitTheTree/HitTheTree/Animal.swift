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
    fileprivate(set) var health: CGFloat = 5.0 {
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
        
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
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
        ghost.position = self.position
        updateMaterials()
        
        var position = self.position
        position.z += 0.15
        let moveTopAction = SCNAction.move(to: position, duration: 0.3)
        moveTopAction.timingMode = .easeOut
        
        position.z = Float(box.width/2.0)
        let moveDownAction = SCNAction.move(to: position, duration: 0.3)
        moveDownAction.timingMode = .easeIn
        
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 0.5)
        moveDownAction.timingMode = .easeIn
        
        let movingAction = SCNAction.sequence([moveTopAction,moveDownAction])
        let movingGroupAction = SCNAction.group([rotateAction,movingAction])
        
        position.z = -Float(box.width)
        let moveDieDownAction = SCNAction.move(to: position, duration: 2.0)
        
        runAction(SCNAction.sequence([movingGroupAction,moveDieDownAction]))
        
        //runAction(DeathAction.deathAction(height: 0.15, duration: 1.0))
        
        parent?.addChildNode(ghost)
        var toPosition = self.position
        toPosition.z += 0.3
        let duration : TimeInterval = 3.0
        let waitAction = SCNAction.wait(duration: movingGroupAction.duration)
        let moveAction = SCNAction.move(to: toPosition, duration: duration)
        let fadeOuttAction = SCNAction.fadeOut(duration: duration)
        let removeAction = SCNAction.removeFromParentNode()
        let group = SCNAction.group([moveAction,fadeOuttAction])
        let totalAction = SCNAction.sequence([waitAction,group,removeAction])
        ghost.runAction(totalAction)
    }
    
    func updateMaterials() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
