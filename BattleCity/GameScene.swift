//
//  GameScene.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 04.09.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var button: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        button = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 100))
        button.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let textLabel = SKLabelNode(text: "Start")
        textLabel.verticalAlignmentMode = .center
        button.addChild(textLabel)
        
        addChild(button)
    }
    
    override func mouseDown(with event: NSEvent) {
        if button.contains(event.location(in: self)) {
            let scene = AnotherScene(size: self.view?.bounds.size ?? .zero)
            scene.scaleMode = .aspectFill

            self.view?.presentScene(scene, transition: .crossFade(withDuration: 0.5))
        } else {
            
        }
    }
}
