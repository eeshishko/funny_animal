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

class GameViewController: UIViewController {
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    //var sceneView: SCNView!
    var scene: SCNScene!
    
    var timer: Timer!
    var animals: [Animal] = []
    let gravity = SCNVector3(0, -0.01, 0)
    var planeIsDetection = false

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
    
    func setupScene() {
        scene = SCNScene(named: "art.scnassets/MainScene.scn")
        sceneView.scene = scene
        sceneView?.allowsCameraControl = true
        
        let pig = AnimalCow()
        pig.position = SCNVector3(0, 0.5, 0)
        scene.rootNode.addChildNode(pig)
        animals.append(pig)
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func updateGameState() {
        print("update game state")
        
        
        for animal in animals {
            if animal.position.y <= 0.5001 {
                var vector = animal.position
                vector.y = 0.5
                animal.position = vector
                animal.velocity = SCNVector3(0.0, 0.2, 0)
            }
            
            let velocity = SCNVector3(animal.velocity.x + gravity.x, animal.velocity.y + gravity.y, animal.velocity.z + gravity.z)
            animal.velocity = velocity
            
            var position = animal.position
            position = SCNVector3(position.x + velocity.x, position.y + velocity.y, position.z + velocity.z)
            animal.position = position
        }
    }
    
    
    func createPlaneNode(anchor: ARPlaneAnchor) -> SCNNode {
        // Create a SceneKit plane to visualize the node using its position and extent.
        
        // Create the geometry and its materials
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let lavaImage = UIImage(named: "art.scnassets/grass.jpg")
        let lavaMaterial = SCNMaterial()
        lavaMaterial.diffuse.contents = lavaImage
        lavaMaterial.isDoubleSided = true
        
        plane.materials = [lavaMaterial]
        
        // Create a node with the plane geometry we created
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        return planeNode
    }
    
    // Try with a floor node instead - this didn't work so well but leaving in for reference
    func createFloorNode(anchor: ARPlaneAnchor) -> SCNNode {
        let floor = SCNFloor()
        
        let lavaImage = UIImage(named: "art.scnassets/grass.jpg")
        
        let lavaMaterial = SCNMaterial()
        lavaMaterial.diffuse.contents = lavaImage
        lavaMaterial.isDoubleSided = true
        
        floor.materials = [lavaMaterial]
        
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        return floorNode
    }

}


extension GameViewController: ARSCNViewDelegate {
    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//
//        return planeNode
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard !planeIsDetection else {
//            return
//        }
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {
//            return
//        }
//        planeIsDetection = true
//        let planeNode = scene.rootNode
//        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
//
//        // SCNPlanes are vertically oriented in their local coordinate space.
//        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//
//        node.addChildNode(planeNode)
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlaneNode(anchor: planeAnchor)
        
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
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
