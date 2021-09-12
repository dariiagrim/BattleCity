//
//  ViewController.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 04.09.2021.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            let scene = GameScene(size: CGSize(width: 1000, height: 750))
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
//            view.showsPhysics = true
            view.showsNodeCount = true
        }
    }
}

