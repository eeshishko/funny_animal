//
//  AnimalWavesMAnager.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 07/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import UIKit


class AnimalWavesManager: NSObject {

    typealias AnimalWave = [Animal.AnimalType:Int]
    
    var waves: [AnimalWave] = []
    
    override init() {
        
    }
    
}
