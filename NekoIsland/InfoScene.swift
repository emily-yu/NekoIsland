//
//  InstructionScene.swift
//  NekoIsland
//
//  Created by VC on 7/16/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

// Copy Paste the GameScene sks and put instructions overlays on them, then have it so
// when a touch is detected it switches to the GameScene

import Foundation
import SpriteKit

class InfoScene: SKScene {
    
    var iconHome: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        // Home Button
        iconHome = self.childNodeWithName("iconHome") as! MSButtonNode
        iconHome.selectedHandler = {
            let skView = self.view as SKView!
            let scene = IntroScene(fileNamed:"IntroScene") as IntroScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }

    }


}