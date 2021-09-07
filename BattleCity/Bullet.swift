//
//  Bullet.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 05.09.2021.
//

import Foundation
import SpriteKit

class Bullet: SKShapeNode {
    convenience init(radius: CGFloat) {
        self.init(circleOfRadius: radius)
        self.fillColor = .white
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.bulletFlag
        self.physicsBody?.contactTestBitMask = Constants.wallFlag | Constants.enemyFlag | Constants.playerFlag
        self.name = "bullet"
    }
    
    func shoot(direction: Rotation, position: CGPoint, gameZoneSize: CGSize) -> SKAction {
        var addBulletY: CGFloat = 0
        var addBulletX: CGFloat = 0
        var bulletMoveAction: SKAction
        switch direction {
        case .left:
            addBulletX = -30
            bulletMoveAction = SKAction.moveTo(x: 0, duration: TimeInterval(position.x / 200))
        case .right:
            addBulletX = 30
            bulletMoveAction = SKAction.moveTo(x: gameZoneSize.width, duration: TimeInterval(position.x / 200))
        case .up:
            addBulletY = 30
            bulletMoveAction = SKAction.moveTo(y: gameZoneSize.height, duration: TimeInterval(position.y / 200))
        case .down:
            addBulletY = -30
            bulletMoveAction = SKAction.moveTo(y: 0, duration: TimeInterval(position.y / 200))
        }
        
        self.position = CGPoint(x: position.x + addBulletX, y: position.y + addBulletY)
        
        return bulletMoveAction
    }
}
