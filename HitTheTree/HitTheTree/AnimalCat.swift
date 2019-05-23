//
//  AnimalCat.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 05/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

extension Animal {

    func catMaterials() {
        let material1 = SCNMaterial()
        material1.diffuse.contents = UIImage(named: "art.scnassets/mouse/bug_2.png")
        material1.locksAmbientWithDiffuse = true
        
        let material1Dead = SCNMaterial()
        material1Dead.diffuse.contents = UIImage(named: "art.scnassets/mouse/bug_2.png")
        material1Dead.locksAmbientWithDiffuse = true
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material2.locksAmbientWithDiffuse = true
        
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material3.locksAmbientWithDiffuse = true
        
        let material4 = SCNMaterial()
        material4.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material4.locksAmbientWithDiffuse = true
        
        let material5 = SCNMaterial()
        material5.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material5.locksAmbientWithDiffuse = true
        
        let material6 = SCNMaterial()
        material6.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material6.locksAmbientWithDiffuse = true
        
        let face = isAlive ? material1 : material1Dead
        box.materials = [face, material2, material3, material4, material5, material6]
    }
    
}
