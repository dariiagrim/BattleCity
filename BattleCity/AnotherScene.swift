//
//  AnotherScene.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 04.09.2021.
//

import Foundation
import SpriteKit

class AnotherScene: SKScene {
    
    private var gameZone :SKSpriteNode!
    private var player   :SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.4454482198, green: 0.4839535356, blue: 0.5355114341, alpha: 1)
        
        gameZone = SKSpriteNode(color: .black, size: CGSize(width: self.size.width - 150, height: self.size.height - 50))
        gameZone.position = CGPoint(x: 40, y: (size.height - gameZone.size.height) / 2)
        gameZone.anchorPoint = CGPoint(x: 0, y: 0)
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 40, height: 40)
        player.position = CGPoint(x: gameZone.size.width / 2 - 80, y: 20)
        
        gameZone.addChild(player)
        
        addChild(gameZone)
    
    }
    
    override func mouseDown(with event: NSEvent) {
        let scene = GameScene(size: self.view?.bounds.size ?? .zero)
        scene.scaleMode = .aspectFill
        
        view?.presentScene(scene, transition: .doorway(withDuration: 0.5))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case Constants.leftArrow:
            player.zRotation =  .pi / 2
            if player.position.x > 40 {
                player.position.x -= 20
            }
        case Constants.rightArrow:
            player.zRotation =  .pi * 3 / 2
            if player.position.x < gameZone.size.width - 40 {
                player.position.x += 20
            }
        case Constants.upArrow:
            player.zRotation =  0
            if player.position.y < gameZone.size.height - 40 {
                player.position.y += 20
            }
        case Constants.downArrow:
            player.zRotation =  .pi
            if player.position.y > 20 {
                player.position.y -= 20
            }
        default:
            break
        }
    }
}
