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
        level1[level1.count - 1][0] = 2
        self.name = "player"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.playerFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.enemyFlag | Constants.bulletFlag
    }
    
    func playerMovement(movementArr: [AStarPoint], gameZoneSize: CGSize) {
            removeAllActions()
            if movementArr.count > 0 {
                var movementArrCopy = movementArr
                let move = movementArrCopy.popLast()
                let x = move!.x
                let y = move!.y
                self.zRotation = rotationToAngle(rotation: move!.direction)
                run(
                    SKAction.sequence([SKAction.move(to: CGPoint(x: arrayToGameZonePosition(coordinate: x), y: arrayToGameZonePosition(coordinate: y)), duration: 0.2), SKAction.run {
                        self.playerMovement(movementArr: movementArrCopy, gameZoneSize: gameZoneSize)
                    }]))
            } else {

                let x = gameZoneToArrayPosition(coordinate: self.position.x)
                let y = gameZoneToArrayPosition(coordinate: self.position.y)
                var possibleToGoPoints = [(x: Int, y: Int)]()
                for (indexY, val)  in level1.enumerated() {
                    for (indexX, wall) in val.enumerated() {
                        if wall == 0 {
                            possibleToGoPoints.append((x: indexX, y: indexY))
                        }
                    }
                }
                let toGoPoint = possibleToGoPoints.randomElement()
                let path: [AStarPoint]
                if let toGoPoint = toGoPoint {
                    level1[toGoPoint.y][toGoPoint.x] = 33
                    path = AStar(start: AStarPoint(x: x, y: y, from: nil, endX: toGoPoint.x, endY: toGoPoint.y, direction: .up), end: AStarPoint(x: toGoPoint.x, y: toGoPoint.y, from: nil, endX: toGoPoint.x, endY: toGoPoint.y, direction: .up))
                    level1[toGoPoint.y][toGoPoint.x] = 0
                } else {
                    path = AStar(start:  AStarPoint(x: x, y: y, from: nil, endX: 0, endY: 0, direction: .up), end: nil)
                }
                playerMovement(movementArr: path, gameZoneSize: gameZoneSize)
            }
    
        }
   
}

