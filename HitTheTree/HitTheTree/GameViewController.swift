//
//  GameViewController.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 11/11/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import ARKit
import AudioToolbox.AudioServices

class GameViewController: UIViewController {
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    //var sceneView: SCNView!
    var scene: SCNScene!
    
    var timer: Timer!
    var animals: [Animal] = []
    let gravity = SCNVector3(0, 0, -0.0002)
    var planeIsDetection = false
    let grassFloor = GrassFloor()

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(GameViewController.updateGameState), userInfo: nil, repeats: true)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @IBAction func didTapShootButton(_ sender: UIButton) {
        shoot()
    }
    
    private func shoot() {
        let arBullet = ARBullet()
        
        let (direction, position) = cameraVector
        arBullet.position = position
        arBullet.initialPosition = position
        
        let bulletDirection = direction
        arBullet.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(arBullet)
        
//        let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
//        AudioServicesPlaySystemSound(vibrate)
        //TODO: check supported device
        
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
    }
    
    func setupScene() {
        scene = SCNScene() //named: "art.scnassets/MainScene.scn")
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func updateGameState() {
        //print("update game state")
        
        
        for animal in animals {
            if animal.position.z <= Float(animal.box.width/2.0 + 0.000001) {
                var vector = animal.position
                vector.z = Float(animal.box.width/2.0)
                animal.position = vector
                animal.velocity = SCNVector3(0.0, 0, 0.005)
            }

            let velocity = SCNVector3(animal.velocity.x + gravity.x, animal.velocity.y + gravity.y, animal.velocity.z + gravity.z)
            animal.velocity = velocity

            var position = animal.position
            position = SCNVector3(position.x + velocity.x, position.y + velocity.y, position.z + velocity.z)
            animal.position = position
        }
    }
    
    func addAnimal() {
        let pig = AnimalCow()
        pig.position = SCNVector3(0, 0, pig.box.width/2.0)//
        pig.eulerAngles = SCNVector3(CGFloat.pi/2, 0, 0)
        grassFloor.addChildNode(pig)
        animals.append(pig)
    }
    

}


extension GameViewController: ARSCNViewDelegate {
    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//
//        return planeNode
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        grassFloor.set(planeAnchor: planeAnchor)
        node.addChildNode(grassFloor)
        if animals.count == 0 {
            addAnimal()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}


// MARK: - Utils

extension GameViewController {
    
    fileprivate var cameraVector: (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, 0), SCNVector3(0, 0, 0))
    }
    
}

// MARK: - SCNPhysicsContactDelegate

extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard let nodeABitMask = contact.nodeA.physicsBody?.categoryBitMask,
            let nodeBBitMask = contact.nodeB.physicsBody?.categoryBitMask,
            nodeABitMask & nodeBBitMask == CollisionCategory.logos.rawValue & CollisionCategory.arBullets.rawValue else {
                return
        }
        print("collision")
        
        
        
        contact.nodeB.removeFromParentNode()
        
        if let animal = contact.nodeA as? Animal {
            animal.damage(value: 0.2)
        }
        
        
//        logoCount -= 1
//
//        if logoCount == 0 {
//            DispatchQueue.main.async {
//                self.stopGame()
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            contact.nodeA.removeFromParentNode()
//        })
    }
    
}
