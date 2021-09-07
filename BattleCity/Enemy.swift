//
//  Enemy.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 06.09.2021.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    convenience init(position: CGPoint) {
        self.init(imageNamed: "enemy")
        self.size = CGSize(width: 40, height: 40)
        self.position = position
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
    }
    
    func enemyMove()  {
        let rotations: [EnemyRotation] = [.up, .down, .left, .right]
        let direction = rotations.randomElement()
        switch direction {
        case .left:
            self.zRotation =  .pi / 2
            self.position.x -= 20
        
        case .right:
            self.zRotation =  .pi * 3 / 2
            self.position.x += 20
        case .up:
            self.zRotation =  0
            self.position.y += 20
        case .down:
            self.zRotation =  .pi
            self.position.y -= 20
        default:
            break
        }
    }
}

enum EnemyRotation {
    case up, down, left, right
}
