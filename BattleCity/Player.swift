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
    var prevXPosition = 0
    var prevYPosition = 0
    convenience init(imageName: String, gameZoneSize: CGSize) {
        self.init(imageNamed: imageName)
        self.size = CGSize(width: 35, height: 35)
        self.position = CGPoint(x: 17.5, y: 17.5)
        self.name = "player"
        level1[0][0]  = 2
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.playerFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.enemyFlag | Constants.bulletFlag
    }
    
    func playerMovement(movementArr: [AStarPoint], gameZoneSize: CGSize, gameZone: GameZone) {
            removeAllActions()
            if movementArr.count > 0 {
                var movementArrCopy = movementArr
                let move = movementArrCopy.popLast()
                let x = move!.x
                let y = move!.y
                let direction = move!.direction
                self.zRotation = rotationToAngle(rotation: direction)
                playerShoot(x: x, y: y, direction: direction, gameZoneSize: gameZoneSize,gameZone: gameZone)
                run(
                    SKAction.sequence([SKAction.move(to: CGPoint(x: arrayToGameZonePosition(coordinate: x), y: arrayToGameZonePosition(coordinate: y)), duration: 0.2), SKAction.run {
                        level1[self.prevYPosition][self.prevXPosition] = 0
                        level1[y][x] = 2
                        self.prevXPosition = x
                        self.prevYPosition = y
                        self.playerMovement(movementArr: movementArrCopy, gameZoneSize: gameZoneSize, gameZone: gameZone)
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
                playerMovement(movementArr: path, gameZoneSize: gameZoneSize, gameZone: gameZone)
            }
    
        }
    
    func playerShoot(x: Int, y: Int, direction: Rotation, gameZoneSize: CGSize, gameZone: GameZone) {
        if checkIfSomethingIsOnTheWay(x: x, y: y, direction: direction, aim: 3) {
            let bullet = Bullet(radius: 5)
            let x = arrayToGameZonePosition(coordinate: x)
            let y = arrayToGameZonePosition(coordinate: y)
            let moveAction = bullet.shoot(direction: direction, position: CGPoint(x: x, y: y), gameZoneSize: gameZoneSize)
            bullet.name = "bulletPlayer"
            gameZone.addChild(bullet)
            bullet.run(moveAction)
        }
    }
}

func checkIfSomethingIsOnTheWay(x: Int, y: Int, direction: Rotation, aim: Int) -> Bool{
    switch direction {
    case .up:
        for i in y..<level1.count {
            if level1[i][x] == aim {
                return true
            }
        }
    case .down:
        for i in 0...y {
            if level1[i][x] == aim {
                return true
            }
        }
    case .right:
        for i in x..<level1[y].count {
            if level1[y][i] == aim {
                return true
            }
        }
    case .left:
        for i in 0...x {
            if level1[y][i] == aim {
                return true
            }
        }
    }
    return false
}


