//
//  Base.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 05.09.2021.
//

import Foundation
import SpriteKit

class Base: SKSpriteNode {
    convenience init(imageName: String, gameZoneSize: CGSize) {
        self.init(imageNamed: imageName)
        self.size = CGSize(width: 40, height: 40)
        self.position = CGPoint(x: gameZoneSize.width / 2, y: 20)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
    }
}
