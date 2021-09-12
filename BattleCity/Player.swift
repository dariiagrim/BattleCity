//
//  Player.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 05.09.2021.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    var direction: Rotation = .up
    
    convenience init(imageName: String, gameZoneSize: CGSize) {
        self.init(imageNamed: imageName)
        self.size = CGSize(width: 35, height: 35)
        self.position = CGPoint(x: 17.5, y: 17.5)
        self.name = "player"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.playerFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.enemyFlag | Constants.bulletFlag
    }
    
    func playerMovement(keyCode: uint16, gameZoneSize: CGSize, level: [[Int]]) {
        removeAllActions()
        
        var x = gameZoneToArrayPosition(coordinate: position.x)
        var y = gameZoneToArrayPosition(coordinate: position.y)
        
        
        var possibleOptions = [Rotation]()
        let levelSize = level.count
        
        if x != 0 && level[levelSize - y - 1][x - 1] == 0 {
            possibleOptions.append(.left)
        }
        if x != level[0].count - 1 && level[levelSize - y - 1][x + 1] == 0 {
            possibleOptions.append(.right)
        }
        if y != 0 && level[levelSize - y][x] == 0 {
            possibleOptions.append(.down)
        }
        if y != levelSize - 1 && level[levelSize - y - 2][x] == 0 {
            possibleOptions.append(.up)
        }
        
        switch keyCode {
        case Constants.leftArrow:
            self.zRotation =  .pi / 2
            self.direction = .left
            if possibleOptions.contains(.left) {
                x -= 1
            }
            
        case Constants.rightArrow:
            self.zRotation =  .pi * 3 / 2
            self.direction = .right
            if possibleOptions.contains(.right) {
                x += 1
            }
        case Constants.upArrow:
            self.zRotation = 0
            self.direction = .up
            if possibleOptions.contains(.up) {
                y += 1
            }
        case Constants.downArrow:
            self.direction = .down
            self.zRotation =  .pi
            if possibleOptions.contains(.down) {
                y -= 1
            }
        default:
            break
        }
        
        run(
            SKAction.move(to: CGPoint(x: arrayToGameZonePosition(coordinate: x), y: arrayToGameZonePosition(coordinate: y)), duration: 0.2)
        )
        
    }
}

