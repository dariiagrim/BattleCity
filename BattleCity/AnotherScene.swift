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
    private var newEnemy = true
    private var minusLife = false
    private var lifes = 3
    private var lifesLeftText: SKLabelNode!
    private var lifesLeftTextNumber: SKLabelNode!
    private var points = 0
    private var pointsText: SKLabelNode!
    private var pointsTextNumber: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.4454482198, green: 0.4839535356, blue: 0.5355114341, alpha: 1)
        
        physicsWorld.contactDelegate = self
        
        lifesLeftText = SKLabelNode(text: "Lifes:")
        lifesLeftText.position = CGPoint(x: 950, y: 450)
        lifesLeftTextNumber = SKLabelNode(text: "\(lifes)")
        lifesLeftTextNumber.position = CGPoint(x: 950, y: 400)
        
        pointsText = SKLabelNode(text: "Points:")
        pointsText.position = CGPoint(x: 950, y: 350)
        pointsTextNumber = SKLabelNode(text: "\(points)")
        pointsTextNumber.position = CGPoint(x: 950, y: 300)
        
        gameZone = GameZone(zoneColor: .black, zoneSize: CGSize(width: 840, height: 700))
       
        player = Player(imageName: "player", gameZoneSize: gameZone.size)
        base = Base(imageName: "base", gameZoneSize: gameZone.size)

        for (indexY, val)  in level1.reversed().enumerated() {
            for (indexX, wall) in val.enumerated() {
                if wall == 1 {
                    let wallNode = WallNode(imageName: "wall", indexX: indexX, indexY: indexY)
                    gameZone.addChild(wallNode)
                }
            }
        }
        
    
        gameZone.addChild(player)
        gameZone.addChild(base)
                
        addChild(gameZone)
        addChild(lifesLeftText)
        addChild(lifesLeftTextNumber)
        addChild(pointsText)
        addChild(pointsTextNumber)
        
    }
    

    
    override func keyDown(with event: NSEvent) {
        player.playerMovement(keyCode: event.keyCode, gameZoneSize: gameZone.size, level: level1)
        switch event.keyCode {
        case Constants.space:
            let bullet = Bullet(radius: 5)
            let bulletMoveAction = bullet.shoot(direction: player.direction, position: player.position, gameZoneSize: gameZone.size)
            gameZone.addChild(bullet)
            bullet.name = "bulletPlayer"
            bullet.run(bulletMoveAction)
        default:
            break
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "bulletPlayer" && contact.bodyB.node?.name == "wall") {
            let x = Int(((contact.bodyB.node!.position.x - 17.5) / 35).rounded(.toNearestOrEven))
            let y = Int(((contact.bodyB.node!.position.y - 17.5) / 35).rounded(.toNearestOrEven))
            level1[level1.count - y - 1][x] = 0
            points += 10
            pointsTextNumber.text = "\(points)"
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "bulletPlayer") {
            let x = Int(((contact.bodyA.node!.position.x - 17.5) / 35).rounded(.toNearestOrEven))
            let y = Int(((contact.bodyA.node!.position.y - 17.5) / 35).rounded(.toNearestOrEven))
            level1[level1.count - y - 1][x] = 0
            points += 10
            pointsTextNumber.text = "\(points)"
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "bulletEnemy" && contact.bodyB.node?.name == "wall") {
            let x = Int(((contact.bodyB.node!.position.x - 17.5) / 35).rounded(.toNearestOrEven))
            let y = Int(((contact.bodyB.node!.position.y - 17.5) / 35).rounded(.toNearestOrEven))
            level1[level1.count - y - 1][x] = 0
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "bulletEnemy") {
            let x = Int(((contact.bodyA.node!.position.x - 17.5) / 35).rounded(.toNearestOrEven))
            let y = Int(((contact.bodyA.node!.position.y - 17.5) / 35).rounded(.toNearestOrEven))
            level1[level1.count - y - 1][x] = 0
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "bulletPlayer" && contact.bodyB.node?.name == "enemy") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            points += 100
            pointsTextNumber.text = "\(points)"
            newEnemy = true
        }
        
        if (contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "bulletPlayer") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            points += 100
            pointsTextNumber.text = "\(points)"
            newEnemy = true
        }
        
        if (contact.bodyA.node?.name == "bulletPlayer" && contact.bodyB.node?.name == "gameZone") {
            contact.bodyA.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "gameZone" && contact.bodyB.node?.name == "bulletPlayer") {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.node?.name == "bulletEnemy" && contact.bodyB.node?.name == "gameZone") {
            contact.bodyA.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "gameZone" && contact.bodyB.node?.name == "bulletEnemy") {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.node?.name == "bulletEnemy" && contact.bodyB.node?.name == "player") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            minusLife = true
        }
        if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "bulletEnemy") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            minusLife = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
      
        if newEnemy {
            newEnemy = false
            let enemy = Enemy(imageName: "enemy")
            gameZone.addChild(enemy)
            enemy.move(level: level1)
            enemy.shoot(gameZone: gameZone)
        }
        
        if minusLife {
            minusLife = false
            lifes -= 1
            if lifes <= 0 {
                openStartScene()
            }
            lifesLeftTextNumber.text = "\(lifes)"
            player = Player(imageName: "player", gameZoneSize: gameZone.size)
            gameZone.addChild(player)
            
        }
    }
    
    func openStartScene() {
        let scene = GameScene(size: self.view?.bounds.size ?? .zero)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: .doorway(withDuration: 0.5))
    }
}
