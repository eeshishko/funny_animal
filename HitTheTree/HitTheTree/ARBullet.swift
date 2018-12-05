//
//  Copyright (c) 2017 Touch Instinct
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the Software), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import SceneKit

final class ARBullet: SCNNode {

    private static let sphereRadius: CGFloat = 0.002
    
    var initialPosition: SCNVector3 = SCNVector3(0,0,0)
    
    var timer: Timer?
    var damage: CGFloat = 1

    override init() {
        super.init()
        initialization()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {[weak self] (timer) in
            self?.removeFromParentNode()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }

    private func initialization() {
        let arKitBox = SCNSphere(radius: ARBullet.sphereRadius)
        self.geometry = arKitBox
        let shape = SCNPhysicsShape(geometry: arKitBox, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = CollisionCategory.arBullets.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.logos.rawValue

        // add texture
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        self.geometry?.materials  = [material]
    }

}
