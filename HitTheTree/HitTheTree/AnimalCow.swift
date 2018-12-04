//
//  AnimalCow.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class AnimalCow: Animal {
    
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
        material1.diffuse.contents = UIImage(named: "art.scnassets/cow/11_01.jpg")
        material1.locksAmbientWithDiffuse = true
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIImage(named: "art.scnassets/cow/11_02.png")
        material2.locksAmbientWithDiffuse = true
        
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIImage(named: "art.scnassets/cow/11_03.png")
        material3.locksAmbientWithDiffuse = true
        
        let material4 = SCNMaterial()
        material4.diffuse.contents = UIImage(named: "art.scnassets/cow/11_04.png")
        material4.locksAmbientWithDiffuse = true
        
        let material5 = SCNMaterial()
        material5.diffuse.contents = UIImage(named: "art.scnassets/cow/11_05.png")
        material5.locksAmbientWithDiffuse = true
        
        let material6 = SCNMaterial()
        material6.diffuse.contents = UIImage(named: "art.scnassets/cow/11_06.png")
        material6.locksAmbientWithDiffuse = true
        
        
        return [material1, material2, material3, material4, material5, material6]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
