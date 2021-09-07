//
//  Enemy.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 07.09.2021.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    
    var rotation: Rotation = .down
    
    convenience init(imageName: String) {
        self.init(imageNamed: imageName)
        self.size = CGSize(width: 35, height: 35)
        self.position = CGPoint(x: CGFloat(Int.random(in: 0..<24)) * 35 + 17.5, y: 682.5)
        self.name = "enemy"
        self.zRotation = .pi
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.enemyFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.playerFlag | Constants.bulletFlag
    }
    
    func move(level: [[Int]]) {
    
        var x = Int(((position.x - 17.5) / 35).rounded(.toNearestOrEven))
        var y = Int(((position.y - 17.5) / 35).rounded(.toNearestOrEven))
        
        var possibleOptions = [Rotation]()
        
        if x != 0 && level[level.count - y - 1][x - 1] == 0 {
            possibleOptions.append(.left)
        }
        if x != level[0].count - 1 && level[level.count - y - 1][x + 1] == 0 {
            possibleOptions.append(.right)
        }
        if y != 0 && level[level.count - y][x] == 0 {
            possibleOptions.append(.down)
        }
        if y != level.count - 1 && level[level.count - y - 2][x] == 0 {
            possibleOptions.append(.up)
        }
        
        let direction = possibleOptions.randomElement()
        
        switch direction {
        case .up:
            y += 1
            zRotation = 0
            rotation = .up
        case .down:
            y -= 1
            zRotation = .pi
            rotation = .down
        case .left:
            x -= 1
            zRotation = .pi / 2
            rotation = .left
        case .right:
            x += 1
            zRotation = .pi * 3 / 2
            rotation = .right
        default:
            move(level: level)
        }
        
        run(SKAction.sequence([
            SKAction.move(to: CGPoint(x: CGFloat(x) * 35 + 17.5, y: CGFloat(y) * 35 + 17.5), duration: 0.5),
            SKAction.run { [weak self] in
                self?.move(level: level)
            }
        ]))
    }
    
    func shoot(gameZone: GameZone) {
        run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run { [self] in
            let bullet = Bullet(radius: 5)
            let bulletMoveAction = bullet.shoot(direction: self.rotation, position: self.position, gameZoneSize: gameZone.size)
            gameZone.addChild(bullet)
            bullet.name = "bulletEnemy"
            bullet.run(bulletMoveAction)
        }, SKAction.run { [weak self] in
                self?.shoot(gameZone: gameZone)
        }]))
    }
}


