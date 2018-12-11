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
	let defaultPlayerName = "Игрок 1"
	
    var maxAnimalsCount = 10
	let minimalRespawnCooldown = 3
	
    @IBOutlet var sceneView: ARSCNView!
    
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    var cloudsManager : CloudsManager!
    
    //var sceneView: SCNView!
    var scene: SCNScene!
    let soundManager = SoundManager()
    
    var timer: Timer!
    var gameTimer: Timer!
    var animals: [Animal] = []
    var planeIsDetection = false
    let grassFloor = GrassFloor()
    var totalPoints: Int = 0
    
    var totalGameTimeSeconds = 0
    
    var animalXCoordinates: [CGFloat] = []
    
    var lastAnimalAddingDate = Date()
    
    let animalsWaves : [Animal.AnimalType] = [.cow, .cow, .cow, .cow, .pig, .pig, .pig, .cat, .cat, .mouse]
    var totalCountHasAddedAnimals: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(GameViewController.updateGameState), userInfo: nil, repeats: true)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        setupAnimalXCoordinates()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.session.pause()
    }
	
	@IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
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
    
    func setupAnimalXCoordinates() {
        animalXCoordinates.removeAll()
        let step : CGFloat = 0.2
        let startX : CGFloat = -grassFloor.plane.width/2.0 + 0.1
        for i in 0..<Int(grassFloor.plane.width/step) {
            animalXCoordinates.append(CGFloat(i) * step + startX)
        }
    }
    
    func setupScene() {
        scene = SCNScene() //named: "art.scnassets/MainScene.scn")
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
        //soundManager.playBackgroundMusic(node: scene.rootNode)
        sceneView.audioListener = scene.rootNode
        soundManager.playBackgroundMusic(node: scene.rootNode)
        startGame()
        
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
            
            if animal.position.y <= Float(grassFloor.redPlaneYCoordinate) {
                timer.invalidate()
                playAnimationRichingRedPlane(animal: animal) {[weak self] in
                    self?.stopGame()
                }
                break
            }
        }
        addAnimal()
    }
    
    func playAnimationRichingRedPlane(animal: Animal, completion: (() -> Void)? ) {
        completion?()
    }
    
    func addAnimal() {
        if animals.count < maxAnimalsCount {
            let addingCount = maxAnimalsCount - animals.count
            
            for _ in 0..<addingCount {
                //тут создаем животное
                createAnimal()
            }
            lastAnimalAddingDate = Date()
        } else {
			if Int(Date().timeIntervalSince1970 - lastAnimalAddingDate.timeIntervalSince1970) > minimalRespawnCooldown {
                lastAnimalAddingDate = Date()
                createAnimal()
            }
        }
        
    }
    
    func createAnimal() {
        let type = animalsWaves[totalCountHasAddedAnimals % animalsWaves.count]
        let level = totalCountHasAddedAnimals / animalsWaves.count
        var animal = Animal.createCow(level: level)
        switch type {
        case .cow:
            animal = Animal.createCow(level: level)
        case .pig:
            animal = Animal.createPig(level: level)
        case .cat:
            animal = Animal.createCat(level: level)
        case .mouse:
            animal = Animal.createMouse(level: level)
        }
        
        animal.position = randomCoordinate(animalSize: animal.box.width) //SCNVector3(0, 0, animal.box.width/2.0 * 3)//
        animal.eulerAngles = SCNVector3(CGFloat.pi/2, 0, 0)
        grassFloor.addChildNode(animal)
        animals.append(animal)
        totalCountHasAddedAnimals += 1
    }
    
    func randomCoordinate(animalSize: CGFloat) -> SCNVector3 {
        var flag = true
        var pos = SCNVector3(0, 0, 0)
        while flag {
            flag = false
            let rand = Int.random(in: 0..<animalXCoordinates.count)
            let width = CGFloat(grassFloor.plane.width/2.0)
            let randomX = animalXCoordinates[rand]
            let randomY = width/2.0 - CGFloat.random(in: -0.1...0.1)
            let randomZ = CGFloat.random(in: animalSize/2...2 * animalSize)
            
            pos = SCNVector3(randomX, randomY, randomZ)
            if animals.count < animalXCoordinates.count {
                for animal in animals {
                    if animal.position.x == pos.x {
                        flag = true
                        break
                    }
                }
            }
            
        }
        return pos
    }
    
    func updateLabels() {
        if totalGameTimeSeconds < 10 {
            self.timeLabel.text = "\(totalGameTimeSeconds/60):0\(totalGameTimeSeconds)"
        } else {
            self.timeLabel.text = "\(totalGameTimeSeconds/60):\(totalGameTimeSeconds)"
        }
        self.pointsLabel.text = "Points: \(totalPoints)"
    }
    
    func restartTimeAndPoints() {
        self.totalGameTimeSeconds = 0
        self.totalPoints = 0
    }
    
    func stopGame() {
        soundManager.stopBackgroundMusic(node: scene.rootNode)
        timer.invalidate()
        gameTimer.invalidate()
		
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let gameOverVc = storyboard.instantiateViewController(withIdentifier: "GameOverViewControllerID") as! GameOverViewController
		
		gameOverVc.delegate = self
        gameOverVc.gameDuration = totalGameTimeSeconds
		
		let result = GameResult(score: self.totalPoints, date: Date())
		gameOverVc.gameResult = result
		
		present(gameOverVc, animated: true, completion: nil)
        
        LeaderBoardManager.manager.finishGame(withDuration: totalGameTimeSeconds)
	}
    
    func startGame() {
        gameTimer?.invalidate()
        restartTimeAndPoints()
        DispatchQueue.main.async {
            self.updateLabels()
        }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] (timer) in
            self?.totalGameTimeSeconds += 1
            DispatchQueue.main.async {
                self?.updateLabels()
            }
        })
        //guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        //grassFloor.set(planeAnchor: planeAnchor)
        grassFloor.position = SCNVector3(0,-0.5,-1)
        scene.rootNode.addChildNode(grassFloor)
        addAnimal()
        cloudsManager = CloudsManager(node: grassFloor, worldWidth: Float(grassFloor.plane.width), worldLength: Float(grassFloor.plane.height))
    }
    
}

extension GameViewController: GameOverViewControllerDelegate {
	func didTapMenuButton(viewController: UIViewController) {
		self.dismiss(animated: true, completion: nil)
	}
}

extension GameViewController: ARSCNViewDelegate {
    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//
//        return planeNode
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
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
            animal.damage(value: 4.0)
            if animal.health == 0 {
                soundManager.playAnimalDead(animal: animal)
                totalPoints += animal.points
                animals = animals.filter({$0.parent != nil})
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
