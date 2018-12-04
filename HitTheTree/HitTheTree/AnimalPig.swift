//
//  AnimalPig.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 03/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import SceneKit

class AnimalPig: Animal {
    

    override init() {
        super.init()
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        box.materials = materials()
        let cubeNode = SCNNode(geometry: box)
        cubeNode.position = SCNVector3(x: 0, y: 0, z: 0)
        addChildNode(cubeNode)
    }
    
    func materials() -> [SCNMaterial] {
        let material1 = SCNMaterial()
        let image = UIImage(named: "art.scnassets/pigFace.jpg")
        material1.diffuse.contents = image
        material1.locksAmbientWithDiffuse = true
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor(red: 248.0/255.0, green: 208.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        material2.locksAmbientWithDiffuse = true
        
        //        SCNMaterial *redMaterial                = [SCNMaterial material];
        //        redMaterial.diffuse.contents            = [NSColor redColor];
        //        redMaterial.locksAmbientWithDiffuse     = YES;
        //
        //        SCNMaterial *blueMaterial               = [SCNMaterial material];
        //        blueMaterial.diffuse.contents           = [NSColor blueColor];
        //        blueMaterial.locksAmbientWithDiffuse    = YES;
        //
        //        SCNMaterial *yellowMaterial             = [SCNMaterial material];
        //        yellowMaterial.diffuse.contents         = [NSColor yellowColor];
        //        yellowMaterial.locksAmbientWithDiffuse  = YES;
        //
        //        SCNMaterial *purpleMaterial             = [SCNMaterial material];
        //        purpleMaterial.diffuse.contents         = [NSColor purpleColor];
        //        purpleMaterial.locksAmbientWithDiffuse  = YES;
        //
        //        SCNMaterial *magentaMaterial            = [SCNMaterial material];
        //        magentaMaterial.diffuse.contents        = [NSColor magentaColor];
        //        magentaMaterial.locksAmbientWithDiffuse = YES;
        //
        //
        return [material1, material1, material1, material1, material1, material1]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
