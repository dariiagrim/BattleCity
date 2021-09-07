//
//  Player.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 05.09.2021.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    var direction: PlayerRotation = .up
    
    convenience init(imageName: String, gameZoneSize: CGSize) {
        self.init(imageNamed: imageName)
        self.size = CGSize(width: 40, height: 40)
        self.position = CGPoint(x: gameZoneSize.width / 2 - 120, y: 20)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
    }
    
    func playerMovement(keyCode: uint16, gameZoneSize: CGSize) {
        switch keyCode {
        case Constants.leftArrow:
            self.zRotation =  .pi / 2
            self.direction = .left
            self.position.x -= 20
        
        case Constants.rightArrow:
            self.zRotation =  .pi * 3 / 2
            self.direction = .right
            self.position.x += 20
        case Constants.upArrow:
            self.zRotation =  0
            self.direction = .up
            self.position.y += 20
        case Constants.downArrow:
            self.direction = .down
            self.zRotation =  .pi
            self.position.y -= 20
        default:
            break
        }
        
    }
}

enum PlayerRotation {
    case up, down, left, right
}
