//
//  SCNVector3Extension.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov imac on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }

    static func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
    }
    
    static func + (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(l.x + r.x, l.y + r.y, l.z + r.z)
    }
    
}
