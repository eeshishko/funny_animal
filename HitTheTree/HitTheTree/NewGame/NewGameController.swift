//
//  NewGameController.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 08/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class NewGameController: UIViewController {

    
    var sceneView: SCNView!
    var arSceneView: ARSCNView!
    let mainScene = MainScene()
    let cameraNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        arSceneView = true ? ARSCNView() : nil
        sceneView = arSceneView != nil ? arSceneView : SCNView()
        view.addSubview(sceneView)
        setup(scene: scene)
        if arSceneView == nil {
            setupCamera(scene: scene)
            sceneView.allowsCameraControl = true
        }
        
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewGameController.tapHandlder))
        sceneView.addGestureRecognizer(tap)
    }
    
    func setupCamera(scene: SCNScene) {
        
        // create and add a camera to the scene
        let camera =  SCNCamera()
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 1, y: 4, z: 10)
    }
    
    func setup(scene: SCNScene) {
        mainScene.position = SCNVector3(0,-2,2)
        scene.rootNode.addChildNode(mainScene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        arSceneView?.session.run(configuration)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds
    }
    
    @objc private func tapHandlder(_ recognizer: UITapGestureRecognizer) {
        let touchPoint = recognizer.location(in: sceneView)
        let pointOfView = sceneView.pointOfView//arSceneView == nil ? sceneView.pointOfView : sceneView.defaultCameraController.pointOfView
        mainScene.tapLocation(hitTests: sceneView.hitTest(touchPoint, options: [.searchMode : SCNHitTestSearchMode.any.rawValue]), pointOfView: pointOfView ?? SCNNode())
    }
    
}

// MARK: - Utils

extension NewGameController {
    
    fileprivate var cameraVector: (position: SCNVector3, direction: SCNVector3)? { // (direction, position)
        if let frame = self.arSceneView?.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        if let mat = cameraNode.camera?.projectionTransform {
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            return (dir, pos)
        }
        
        return nil
    }
    
}
