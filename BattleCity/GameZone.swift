//
//  GameZone.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 05.09.2021.
//

import Foundation
import SpriteKit

class GameZone: SKSpriteNode {
    convenience init(zoneColor: NSColor, zoneSize: CGSize) {
        self.init(color: zoneColor, size: zoneSize)
        self.position = CGPoint(x: 50, y: 25)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: zoneSize.width, height: zoneSize.height))
        self.physicsBody?.affectedByGravity = false
        self.name = "gameZone"
    }
    

}
