//
//  NewGameController.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 08/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import SceneKit

class NewGameController: UIViewController {

    @IBOutlet var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        setup(scene: scene)
        
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
    }
    
    func setup(scene: SCNScene) {
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 10)
        
        let mainSceneNode = MainScene()
        scene.rootNode.addChildNode(mainSceneNode)
    }
    
}
