//
//  Missle.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 17/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class Missle: SCNNode {

    private static let sphereRadius: CGFloat = 0.1
    
    var initialPosition: SCNVector3 = SCNVector3(0,0,0)
    
    var timer: Timer?
    var damage: CGFloat = 1
    
    init(hasRigidBody: Bool) {
        super.init()
        initialization(hasRigidBody: hasRigidBody)
    }
    
    override init() {
        super.init()
        initialization()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {[weak self] (timer) in
            self?.removeFromParentNode()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    private func initialization(hasRigidBody: Bool = true) {
        let arKitBox = SCNSphere(radius: Missle.sphereRadius)
        self.geometry = arKitBox
        if hasRigidBody {
            let shape = SCNPhysicsShape(geometry: arKitBox, options: nil)
            self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
            self.physicsBody?.isAffectedByGravity = false
            
//            self.physicsBody?.categoryBitMask = CollisionCategory.arBullets.rawValue
//            self.physicsBody?.contactTestBitMask = CollisionCategory.logos.rawValue
        }
        
        // add texture
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        self.geometry?.materials  = [material]
    }
    
    func showSmokeCloud() {
        
    }
    
}
