//
//  AnimalPig.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 03/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit
import SceneKit

extension Animal {
    
    func pigMaterials() {
        let material1 = SCNMaterial()
        material1.diffuse.contents = UIImage(named: "art.scnassets/pig/bug_3.png")
        material1.locksAmbientWithDiffuse = false
        
        let material1Dead = SCNMaterial()
        material1Dead.diffuse.contents = UIImage(named: "art.scnassets/pig/bug_3.png")
        material1Dead.locksAmbientWithDiffuse = false
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material2.locksAmbientWithDiffuse = false
        
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material3.locksAmbientWithDiffuse = false
        
        let material4 = SCNMaterial()
        material4.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material4.locksAmbientWithDiffuse = false
        
        let material5 = SCNMaterial()
        material5.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material5.locksAmbientWithDiffuse = false
        
        let material6 = SCNMaterial()
        material6.diffuse.contents = UIImage(named: "art.scnassets/empty.png")
        material6.locksAmbientWithDiffuse = false
        
        let face = isAlive ? material1 : material1Dead
        box.materials = [face, material2, material3, material4, material5, material6]
    }
    
}
