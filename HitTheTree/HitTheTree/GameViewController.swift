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


let kGravity = SCNVector3(0, 0, -0.0002)

class GameViewController: UIViewController {
    
    var maxAnimalsCount = 10
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    
    //var sceneView: SCNView!
    var scene: SCNScene!
    let soundManager = SoundManager()
    
    var timer: Timer!
    var gameTimer: Timer!
    var animals: [Animal] = []
    var planeIsDetection = false
    let grassFloor = GrassFloor()
    var totalPoints: Int = 0
    
    var secondsToFinish = 60

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
        
        soundManager.playShootSound(node: sceneView.scene.rootNode)
    }
    
    func setupScene() {
        scene = SCNScene() //named: "art.scnassets/MainScene.scn")
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
        //soundManager.playBackgroundMusic(node: scene.rootNode)
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
            
            if !animal.isAlive {
                continue
            }
            
            if animal.position.z <= Float(animal.box.width/2.0 + 0.000001) {
                var vector = animal.position
                vector.z = Float(animal.box.width/2.0)
                animal.position = vector
                animal.velocity = animal.defaultVelocity
            }

            let velocity = animal.velocity + kGravity
            animal.velocity = velocity

            var position = animal.position
            position = SCNVector3(position.x + velocity.x, position.y + velocity.y, position.z + velocity.z)
            animal.position = position
        }
    }
    
    func addAnimal() {
        if animals.count > maxAnimalsCount {
            return
        }
        let randomInt = Int.random(in: 1...4)
        let animalType = Animal.AnimalType(rawValue: randomInt) ?? .cow
        var animal = Animal.createCow()
        
        switch animalType {
        case .cow:
            animal = Animal.createCow()
        case .pig:
            animal = Animal.createPig()
        case .cat:
            animal = Animal.createCat()
        case .mouse:
            animal = Animal.createMouse()
        }
        
        
        animal.position = randomCoordinate(size: animal.box.width) //SCNVector3(0, 0, animal.box.width/2.0 * 3)//
        animal.eulerAngles = SCNVector3(CGFloat.pi/2, 0, 0)
        grassFloor.addChildNode(animal)
        animals.append(animal)
    }
    
    func randomCoordinate(size: CGFloat) -> SCNVector3 {
        var flag: Bool = true
        var newPosition = SCNVector3(0, 0, 0)
        while flag {
            let randomX = CGFloat.random(in: (-0.5+size/2.0)...(0.5-size/2.0))
            let randomY = CGFloat.random(in: (-0.5+size/2.0)...(0.5-size/2.0))
            let randomZ = CGFloat.random(in: size/2...2 * size)
            newPosition = SCNVector3(randomX, randomY, randomZ)
            flag = false
            for animal in animals {
                let length = sqrtf(powf((animal.position.x - newPosition.x), 2.0) + pow((animal.position.y - newPosition.y), 2.0))
                if length < 0.3 {
                    flag = true
                    break
                }
            }
        }
        return newPosition
    }
    
    func updateLabels() {
        self.timeLabel.text = "\(secondsToFinish/60):\(secondsToFinish)"
        self.pointsLabel.text = "Points: \(totalPoints)"
    }
    
    func restartTimeAndPoints() {
        self.secondsToFinish = 60
        self.totalPoints = 0
    }
    
    func decreaseSecondsToFinish() {
        secondsToFinish -= 1
        if secondsToFinish < 0 {
            stopGame()
        }
    }
    
    func stopGame() {
        
    }

}


extension GameViewController: ARSCNViewDelegate {
    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//
//        return planeNode
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        gameTimer?.invalidate()
        restartTimeAndPoints()
        DispatchQueue.main.async {
            self.updateLabels()
        }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] (timer) in
            self?.decreaseSecondsToFinish()
            DispatchQueue.main.async {
                self?.updateLabels()
            }
        })
        sceneView.audioListener = scene.rootNode
        soundManager.playBackgroundMusic(node: node)
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        grassFloor.set(planeAnchor: planeAnchor)
        node.addChildNode(grassFloor)
        for _ in 0..<maxAnimalsCount {
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
        
        if let animal = contact.nodeA as? Animal, animal.isAlive {
            animal.damage(value: 0.2)
            if animal.health == 0 {
                soundManager.playAnimalDead(animal: animal)
                totalPoints += animal.points
                if let index = animals.lastIndex(of: animal) {
                    animals.remove(at: index)
                }
            }
            DispatchQueue.main.async {
                self.updateLabels()
            }
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
