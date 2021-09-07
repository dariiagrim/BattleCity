//
//  AnotherScene.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 04.09.2021.
//

import Foundation
import SpriteKit

class AnotherScene: SKScene, SKPhysicsContactDelegate {
    
    private var gameZone: GameZone!
    private var player: Player!
    private var base: Base!
    private var enemies: [Enemy]!
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.4454482198, green: 0.4839535356, blue: 0.5355114341, alpha: 1)
        
        physicsWorld.contactDelegate = self
        
        gameZone = GameZone(zoneColor: .black, zoneSize: CGSize(width: 640, height: 560))
       
        player = Player(imageName: "player", gameZoneSize: gameZone.size)
        base = Base(imageName: "base", gameZoneSize: gameZone.size)
        let enemy1 = Enemy(position: CGPoint(x: 80, y: gameZone.size.height - 20))
        let enemy2 = Enemy(position: CGPoint(x: 160, y: gameZone.size.height - 20))
        let enemy3 = Enemy(position: CGPoint(x: 240, y: gameZone.size.height - 20))
        enemies = [enemy1, enemy2, enemy3]
        

        for (indexY, val)  in level1.reversed().enumerated() {
            for (indexX, wall) in val.enumerated() {
                if wall == 1 {
                    let wallNode = SKSpriteNode(imageNamed: "wall")
                    wallNode.size = CGSize(width: 20, height: 20)
                    wallNode.position = CGPoint(x: indexX * 20 + 10, y: indexY * 20 + 10)
                    wallNode.physicsBody = SKPhysicsBody(rectangleOf: wallNode.size)
                    wallNode.physicsBody?.affectedByGravity = false
                    wallNode.physicsBody?.isDynamic = false
                    wallNode.physicsBody?.categoryBitMask = Constants.wallFlag
                    wallNode.physicsBody?.contactTestBitMask = Constants.bulletFlag
                    wallNode.name = "wall"
                    gameZone.addChild(wallNode)
                }
            }
        }
        
        for val in enemies {
            gameZone.addChild(val)
        }
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            enemy1.enemyMove()
            print("hello")
        }, SKAction.wait(forDuration: 0.5)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            enemy2.enemyMove()
            print("hello")
        }, SKAction.wait(forDuration: 0.5)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            enemy3.enemyMove()
            print("hello")
        }, SKAction.wait(forDuration: 0.5)])))
    
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
        player.playerMovement(keyCode: event.keyCode, gameZoneSize: gameZone.size)
        switch event.keyCode {
        case Constants.space:
            let bullet = Bullet(radius: 5)
            let bulletMoveAction = bullet.playerShoot(direction: player.direction, playerPosition: player.position, gameZoneSize: gameZone.size)
            gameZone.addChild(bullet)
            bullet.run(bulletMoveAction)
        default:
            break
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
     
        if (contact.bodyA.node?.name == "bullet" && contact.bodyB.node?.name == "wall") {
            contact.bodyA.node?.removeFromParent()
            let position = contact.bodyB.node!.position
            let index1 = abs(27 - Int(round(round(position.y - 10) / 20)))
            let index2 = Int(round(round(position.x - 10) / 20))
            level1[index1][index2] = 0
            contact.bodyB.node?.removeFromParent()
            run(SKAction.sequence([
                SKAction.run({
                    let flash = SKSpriteNode(imageNamed: "flash")
                    flash.position = position
                    flash.size = CGSize(width: 20, height: 20)
                    self.gameZone.addChild(flash)
                })
            ]))
        }
        
        if (contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "bullet") {
            let position = contact.bodyA.node!.position
            let index1 = abs(27 - Int(round(round(position.y - 10) / 20)))
            let index2 = Int(round(round(position.x - 10) / 20))
            level1[index1][index2] = 0
            print(level1)
            print(index1, index2)
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            let flash = SKSpriteNode(imageNamed: "flash")
            flash.position = position
            flash.size = CGSize(width: 20, height: 20)
            run(SKAction.sequence([
                SKAction.run({
                    self.gameZone.addChild(flash)
                }),
                SKAction.wait(forDuration: 0.5),
                SKAction.run {
                    flash.removeFromParent()
                }
            ]))
        }
        
        if (contact.bodyA.node?.name == "bullet" && contact.bodyB.node?.name == "gameZone") {
            contact.bodyA.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "gameZone" && contact.bodyB.node?.name == "bullet") {
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    
}
