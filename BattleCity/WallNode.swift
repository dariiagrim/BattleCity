//
//  WallNode.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 07.09.2021.
//

import Foundation
import SpriteKit

class WallNode: SKSpriteNode {
    convenience init(imageName: String, indexX: Int, indexY: Int) {
        self.init(imageNamed: imageName)
        self.size = CGSize(width: 35, height: 35)
        self.position = CGPoint(x: CGFloat(indexX) * 35 + 17.5, y: CGFloat(indexY) * 35 + 17.5)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = Constants.wallFlag
        self.physicsBody?.collisionBitMask = Constants.playerFlag | Constants.enemyFlag
        self.physicsBody?.contactTestBitMask = Constants.bulletFlag
        self.name = "wall"
    }
}
