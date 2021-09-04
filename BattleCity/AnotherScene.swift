//
//  AnotherScene.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 04.09.2021.
//

import Foundation
import SpriteKit

class AnotherScene: SKScene {
    
    private var gameZone: SKSpriteNode!
    private var player: SKSpriteNode!
    private var base: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.4454482198, green: 0.4839535356, blue: 0.5355114341, alpha: 1)
        
        gameZone = SKSpriteNode(color: .black, size: CGSize(width: 640, height: 560))
        gameZone.position = CGPoint(x: 40, y: 20)
        gameZone.anchorPoint = CGPoint(x: 0, y: 0)
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 40, height: 40)
        player.position = CGPoint(x: gameZone.size.width / 2 - 80, y: 20)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        base = SKSpriteNode(imageNamed: "base")
        base.size = CGSize(width: 40, height: 40)
        base.position = CGPoint(x: gameZone.size.width / 2, y: 20)
        base.physicsBody = SKPhysicsBody(rectangleOf: base.size)
        base.physicsBody?.affectedByGravity = false
        
        for (indexY, val)  in level1.reversed().enumerated() {
            for (indexX, wall) in val.enumerated() {
                if wall == 1 {
                    let wallNode = SKSpriteNode(imageNamed: "wall")
                    wallNode.size = CGSize(width: 20, height: 20)
                    wallNode.position = CGPoint(x: indexX * 20 + 10, y: indexY * 20 + 10)
                    wallNode.physicsBody = SKPhysicsBody(rectangleOf: wallNode.size)
                    wallNode.physicsBody?.affectedByGravity = false
                    wallNode.physicsBody?.isDynamic = false
                    gameZone.addChild(wallNode)
                }
            }
        }
        
        
        
        gameZone.addChild(player)
        gameZone.addChild(base)
        
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
