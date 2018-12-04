//
//  SoundManager.swift
//  HitTheTree
//
//  Created by Marat Khuzhayarov on 04/12/2018.
//  Copyright © 2018 Marat Khuzhayarov. All rights reserved.
//

import SceneKit

class SoundManager: NSObject {

    private var sounds:[String:SCNAudioSource] = [:]
    private var musicPlayer: SCNAudioPlayer!
    
    override init() {
        super.init()
        setupSound()
    }
    
    private func setupSound() {
        
        let hitSound = SCNAudioSource(fileNamed: "animalHit.mp3")!
        hitSound.load()
        hitSound.volume = 0.3
        
        let shootSound = SCNAudioSource(fileNamed: "shoot.wav")!
        shootSound.load()
        shootSound.volume = 0.3
        
        sounds["hit"] = hitSound
        sounds["shoot"] = shootSound
        
        let backgroundMusic = SCNAudioSource(fileNamed: "background.mp3")!
        backgroundMusic.volume = 0.8
        backgroundMusic.loops = true
        backgroundMusic.load()
        
        musicPlayer = SCNAudioPlayer(source: backgroundMusic)
    }
    
    func playBackgroundMusic(node: SCNNode) {
        node.addAudioPlayer(musicPlayer)
    }
    
    func playHitSound(node: SCNNode) {
        let hitSound = sounds["hit"]!
        node.runAction(SCNAction.playAudio(hitSound, waitForCompletion: true))
    }
    
    func playShootSound(node: SCNNode) {
        let shootSound = sounds["shoot"]!
        node.runAction(SCNAction.playAudio(shootSound, waitForCompletion: true))
    }
    
}
