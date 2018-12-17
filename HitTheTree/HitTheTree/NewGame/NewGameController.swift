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

    @IBOutlet var aimImageView: UIImageView!
    var sceneView: SCNView!
    var arSceneView: ARSCNView!
    let mainScene = MainScene()
    let cameraNode = SCNNode()
    var bulletTimer: Timer?
    
    var aimCenterCoordinate: CGPoint {
        get {
            if let imageView = aimImageView {
                let center = CGPoint(x: imageView.bounds.width/2.0, y: imageView.bounds.height/2.0)
                return imageView.convert(center, to: sceneView)
            }
            return CGPoint.zero
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()//SCNScene(named: "art.scnassets/scene.scn")!
        arSceneView = false ? ARSCNView() : nil
        sceneView = arSceneView != nil ? arSceneView : SCNView()
        view.insertSubview(sceneView, belowSubview: aimImageView)
        setup(scene: scene)
        if arSceneView == nil {
            setupCamera(scene: scene)
            sceneView.allowsCameraControl = true
        }
        
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.backgroundColor = UIColor.black
        
    }
    
    func setupCamera(scene: SCNScene) {
        
        // create and add a camera to the scene
        let camera =  SCNCamera()
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 7)
    }
    
    func setup(scene: SCNScene) {
        mainScene.position = SCNVector3(0,-2,2)
        scene.rootNode.addChildNode(mainScene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        arSceneView?.session.run(configuration)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds
    }
    
    fileprivate func shoot() {
        let pointOfView = sceneView.pointOfView ?? SCNNode()
        let shootPoint = CGPoint(x: sceneView.frame.width * 0.2, y: sceneView.frame.height * 1.0)//touchPoint//
        let shootPoint3D = sceneView.unprojectPoint(SCNVector3(shootPoint.x, shootPoint.y, 0))//pointOfView.convertPosition(, from: nil)
        let hitTests = sceneView.hitTest(aimCenterCoordinate, options: [.searchMode : SCNHitTestSearchMode.any.rawValue])
        mainScene.tapLocation(hitTests: hitTests, pointOfView: pointOfView, shootPoint: shootPoint3D)
    }
    
    @IBAction private func startBulletAction(_ sender: UIButton) {
        bulletTimer?.invalidate()
        shoot()
        bulletTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {[weak self] (timer) in
            self?.shoot()
        })
    }
    
    @IBAction private func endBulletAction(_ sender: UIButton) {
        bulletTimer?.invalidate()
        bulletTimer = nil
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
