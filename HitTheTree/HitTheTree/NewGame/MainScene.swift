//
//  MainScene.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 08/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit
import AudioToolbox.AudioServices


protocol MainSceneDelegate: NSObjectProtocol {
    func stopGame(duration: Int, totalPoints: Int)
    func updateLabels(seconds: Int, points: Int)
}

class MainScene: SCNNode {
    weak var delegate: MainSceneDelegate?
    let defaultPlayerName = "Игрок 1"
    
    var maxAnimalsCount = 10
    let minimalRespawnCooldown = 3
    
    private let redPlaneNode = SCNNode()
    
    
    //var sceneView: SCNView!
    var scene: SCNScene!
    let soundManager = SoundManager()
    
    var timer: Timer!
    var gameTimer: Timer!
    var animals: [Animal] = []
    var planeIsDetection = false
    var totalPoints: Int = 0
    
    var totalGameTimeSeconds = 0
    
    var animalXCoordinates: [CGFloat] = []
    
    var lastAnimalAddingDate = Date()
    
    let animalsWaves : [Animal.AnimalType] = [.cow, .cow, .cow, .cow, .pig, .pig, .pig, .cat, .cat, .mouse]
    var totalCountHasAddedAnimals: Int = 0
    
    let floor = SCNFloor()
    let floorNode = SCNNode()
    
    let rockManager = RockManager()
    var cloudsManager: NewCloudsManager!

    override init() {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(MainScene.updateGameState), userInfo: nil, repeats: true)
        setupAnimalXCoordinates()
        setupFloor()
        setupLight()
        cloudsManager = NewCloudsManager(node: self, worldWidth: Float(floor.width), worldLength: Float(floor.length))
        setupFence()
        addTree()
        soundManager.playBackgroundMusic(node: self)
        startGame()
        setupRedPlane()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapLocation(hitTests: [SCNHitTestResult], pointOfView: SCNNode, shootPoint: SCNVector3 = SCNVector3(0, -1, 0)) {
        if let firstHitTest = hitTests.filter({$0.node.name == "floor"}).first {
            let node = firstHitTest.node
            var pos = convertPosition(firstHitTest.localCoordinates, from: node)
            pos.z = 0
//            pos.x += Float.random(in: -0.3...0.3)
//            pos.y += Float.random(in: -0.3...0.3)
            
            let shootP = pointOfView.convertPosition(shootPoint, from: nil)
            let position1 = convertPosition(shootP, from: pointOfView)
            var direction1 = SCNVector3((pos.x - position1.x) * 1.0, (pos.y - position1.y) * 1.0, (pos.z - position1.z) * 1.0)

            
            direction1 = convertVector(direction1, to: nil)
            print("position: \(position1)  direction: \(direction1)")
            shoot(position: position1, direction: direction1)
        }
    }
    
    fileprivate func setupFloor() {
        floor.width = 2.5 + 0.2
        floor.length = 2.5
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
        light.intensity = 500 * itencityScale
        light.color = UIColor(white: 0.75, alpha: 1.0)
        light.type = .ambient
        light.castsShadow = true
        ambientNode.light = light
        addChildNode(ambientNode)

        
        let frontDirNode = SCNNode()
        let front1 = SCNLight()
        front1.intensity = 1700 * itencityScale
        front1.color = UIColor(white: 0.5, alpha: 1.0)
        front1.type = .directional
        front1.castsShadow = true
        front1.maximumShadowDistance = 1000
        frontDirNode.light = front1
        frontDirNode.position = SCNVector3(floor.length * 1.2,0,1)
        frontDirNode.eulerAngles = SCNVector3(CGFloat.pi/4, CGFloat.pi/4, 0)
        addChildNode(frontDirNode)
        
        
        let frontDirNode2 = SCNNode()
        let front2 = SCNLight()
        front2.intensity = 1100 * itencityScale
        front2.color = UIColor(white: 0.5, alpha: 1.0)
        front2.type = .directional
        front2.castsShadow = true
        frontDirNode2.light = front2
        frontDirNode2.position = SCNVector3(-floor.length * 1.2,0,1)
        frontDirNode2.eulerAngles = SCNVector3(CGFloat.pi/2,0,0)
        addChildNode(frontDirNode2)
        
        
//        let cloudeTopLightNode = SCNNode()
//        let cloudeTopLight = SCNLight()
//        cloudeTopLight.intensity = 1000 * itencityScale
//        cloudeTopLight.color = UIColor(red: 63.0/255.0, green: 167.0/255.0, blue: 212.0/255.0, alpha: 1.0)
//        cloudeTopLight.categoryBitMask = 4
//        cloudeTopLight.type = .directional
//        cloudeTopLightNode.light = cloudeTopLight
//        cloudeTopLightNode.position = SCNVector3(0,0,0)
//        cloudeTopLightNode.eulerAngles = SCNVector3(0,0,0)
//        addChildNode(cloudeTopLightNode)
    }
    
    fileprivate func addCube(position: SCNVector3 = SCNVector3(0,2,0)) {
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let mat = SCNMaterial()
        mat.lightingModel = .lambert
        mat.diffuse.contents = UIColor.white
        box.materials = [mat]
        let node = SCNNode()
        node.geometry = box
        node.position = position
        addChildNode(node)
    }
    
    fileprivate func addRock() {
        let rock1 = RockManager.createRock1()
        rock1.position = SCNVector3(0,0,0)
        addChildNode(rock1)
    }
    
    fileprivate func addTree() {
        let scene = SCNScene(named: "art.scnassets/pine_node.scn")
        let tree = scene?.rootNode.childNode(withName: "tree", recursively: true) ?? SCNNode()
        tree.position = SCNVector3(0,0,0)
        addChildNode(tree)
    }
    
    
    private func shoot(position: SCNVector3, direction: SCNVector3) {
        let arBullet = ARBullet()
        
        arBullet.position = position
        arBullet.initialPosition = position
        
        let bulletDirection = direction.normalized() * 10
        arBullet.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        addChildNode(arBullet)
        
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
        
        //soundManager.playShootSound(node: sceneView.scene.rootNode)
    }
    
    func setupAnimalXCoordinates() {
        animalXCoordinates.removeAll()
        let step : CGFloat = 0.5
        let startX : CGFloat = -2.25
        for i in 0..<10 {
            let x = CGFloat(i) * step + startX
            animalXCoordinates.append(x)
        }
    }
    
    private func setupFence() {
        for i in 0...10 {
            let x = Float(i) * 0.5 - 2.5
            for j in 0..<4 {
                let scene = SCNScene(named: "art.scnassets/line_fence.scn")
                let fence = scene?.rootNode.childNode(withName: "fence", recursively: true) ?? SCNNode()
                let widthFence: Float = 0.65
                let y = widthFence/2.0 + (0.01 + widthFence/2.0) * Float(j)
                fence.position = SCNVector3(x, y, 0)
                addChildNode(fence)
            }
        }
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
            
            if animal.position.y <= Float(redPlaneNode.position.y) {
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
        addChildNode(animal)
        animals.append(animal)
        totalCountHasAddedAnimals += 1
    }
    
    func randomCoordinate(animalSize: CGFloat) -> SCNVector3 {
        var flag = true
        var pos = SCNVector3(0, 0, 0)
        while flag {
            flag = false
            let rand = Int.random(in: 0..<animalXCoordinates.count)
            let length = floor.length
            let randomX = animalXCoordinates[rand]
            let randomY = length - CGFloat.random(in: -0.1...0.1)
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
    
    func restartTimeAndPoints() {
        self.totalGameTimeSeconds = 0
        self.totalPoints = 0
    }
    
    func stopGame() {
        soundManager.stopBackgroundMusic(node: self)
        timer.invalidate()
        gameTimer.invalidate()
        delegate?.stopGame(duration: totalGameTimeSeconds, totalPoints: totalPoints)
    }
    
    func startGame() {
        gameTimer?.invalidate()
        restartTimeAndPoints()
        DispatchQueue.main.async {
            self.delegate?.updateLabels(seconds: self.totalGameTimeSeconds, points: self.totalPoints)
        }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] (timer) in
            guard let `self` = self else {
                return
            }
            self.totalGameTimeSeconds += 1
            DispatchQueue.main.async {
                self.delegate?.updateLabels(seconds: self.totalGameTimeSeconds, points: self.totalPoints)
            }
        })
        addAnimal()
    }
    
    
    func setupRedPlane() {
        let redPlaneYCoordinate: CGFloat = -0.8 * floor.length
        redPlaneNode.position = SCNVector3(0,redPlaneYCoordinate,0.00001)
        let redPlane = SCNPlane()
        redPlane.width = floor.width * 2
        redPlane.height = 0.01
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        redPlane.materials = [material]
        redPlaneNode.geometry = redPlane
        addChildNode(redPlaneNode)
    }
    
}





// MARK: - SCNPhysicsContactDelegate

extension MainScene: SCNPhysicsContactDelegate {
    
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
                self.delegate?.updateLabels(seconds: self.totalGameTimeSeconds, points: self.totalPoints)
            }
        }
    }
    
}
