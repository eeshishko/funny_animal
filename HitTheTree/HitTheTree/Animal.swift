//
//  Animal.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class Animal: SCNNode {
    enum AnimalType: Int {
        case cow = 1, pig, cat, mouse
    }

	fileprivate static let YSpeedValue: CGFloat = -0.0009
    fileprivate(set) var defaultVelocity : SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    var velocity : SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    fileprivate var maxHealth: CGFloat = 5.0
    fileprivate(set) var health: CGFloat = 5.0 {
        didSet {
            healthBar.health = health/maxHealth
        }
    }
    private let healthBar = HealthBar()
    fileprivate(set) var isAlive = true
    fileprivate let ghost: Ghost
    fileprivate(set) var type: AnimalType = .cow
    fileprivate(set) var points: Int = 100
    
    fileprivate(set) var box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
    
    init(box: SCNBox = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)) {
        let ghostBox = SCNBox(width: box.width * 0.9, height: box.height * 0.9, length: box.length * 0.9, chamferRadius: box.chamferRadius * 0.9)
        ghost = Ghost(box: ghostBox)
        ghost.eulerAngles = SCNVector3(CGFloat.pi/2, 0, 0)
        super.init()
        self.box = box
        let cubeNode = SCNNode(geometry: box)
        cubeNode.position = SCNVector3(x: 0, y: 0, z: 0)
        addChildNode(cubeNode)
        updateMaterials()
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
        position.z += Float(box.width * 3)
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
        let moveDieDownAction = SCNAction.move(to: position, duration: 5.0)
        
        //runAction(DeathAction.deathAction(height: 0.15, duration: 1.0))
        
        parent?.addChildNode(ghost)
        var toPosition = self.position
        toPosition.z += 0.3
        let duration : TimeInterval = 8.0
        let waitAction = SCNAction.wait(duration: movingGroupAction.duration)
        let moveAction = SCNAction.move(to: toPosition, duration: duration)
        let fadeOuttAction = SCNAction.fadeOut(duration: duration)
        let removeAction = SCNAction.removeFromParentNode()
        let group = SCNAction.group([moveAction,fadeOuttAction])
        let totalAction = SCNAction.sequence([waitAction,group,removeAction])
        ghost.runAction(totalAction)
        
        let waitAnimalAction = SCNAction.wait(duration: 3)
        let removeAnimalAction = SCNAction.removeFromParentNode()
        runAction(SCNAction.sequence([movingGroupAction,moveDieDownAction, waitAnimalAction, removeAnimalAction]))
    }
    
    func updateMaterials() {
        switch type {
        case .cow:
            cowMaterials()
        case .pig:
            pigMaterials()
        case .cat:
            catMaterials()
        case .mouse:
            mouseMaterials()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func health(level: Int, maxHealth: CGFloat) -> CGFloat {
        return maxHealth + CGFloat(level) * 0.2
    }
	
	private static func YSpeed(level: Int) -> CGFloat {
		return YSpeedValue - CGFloat(level) * 0.0002
	}
    
    static func createCow(level: Int = 0) -> Animal {
        let size: CGFloat = 0.1
        let animal = Animal(box: SCNBox(width: size, height: size, length: size, chamferRadius: 0))
        animal.type = .cow
        animal.defaultVelocity = SCNVector3(0, YSpeed(level: level), 0.002)
        animal.cowMaterials()
        animal.maxHealth = health(level: level, maxHealth: 15)
        animal.health = animal.maxHealth
        animal.points = 100
        return animal
    }
    
    static func createPig(level: Int = 0) -> Animal {
        let size: CGFloat = 0.07
        let animal = Animal(box: SCNBox(width: size, height: size, length: size, chamferRadius: 0))
        animal.type = .pig
        animal.defaultVelocity = SCNVector3(0, YSpeed(level: level), 0.003)
        animal.pigMaterials()
        animal.maxHealth = health(level: level, maxHealth: 10)
        animal.health = animal.maxHealth
        animal.points = 200
        return animal
    }
    
    static func createCat(level: Int = 0) -> Animal {
        let size: CGFloat = 0.05
        let animal = Animal(box: SCNBox(width: size, height: size, length: size, chamferRadius: 0))
        animal.type = .cat
        animal.defaultVelocity = SCNVector3(0, YSpeed(level: level), 0.005)
        animal.catMaterials()
        animal.maxHealth = health(level: level, maxHealth: 5)
        animal.health = animal.maxHealth
        animal.points = 500
        return animal
    }
    
    static func createMouse(level: Int = 0) -> Animal {
        let size: CGFloat = 0.03
        let animal = Animal(box: SCNBox(width: size, height: size, length: size, chamferRadius: 0))
        animal.type = .mouse
        animal.defaultVelocity = SCNVector3(0, YSpeed(level: level), 0.007)
        animal.mouseMaterials()
        animal.maxHealth = health(level: level, maxHealth: 2.0)
        animal.health = animal.maxHealth
        animal.points = 1000
        return animal
    }
    
}
