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
    var pause = false
    var prevXPosition = 0
    var prevYPosition = 0
    var arrayX: Int {
        get {
            return gameZoneToArrayPosition(coordinate: position.x)
        }
    }
    var arrayY: Int {
        get {
            return gameZoneToArrayPosition(coordinate: position.y)
        }
    }
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
    
    func move(path: [Point]) {
        guard !pause else { return }
        var pathCopy: [Point]
        if path.count == 0 {
            pathCopy = DFS(startX: arrayX, startY: arrayY)
        } else {
            pathCopy = path
        }
        if pathCopy.count > 0 {
            let move = pathCopy.removeFirst()
            let x = move.x
            let y = move.y
            let direction = move.direction
            self.zRotation = rotationToAngle(rotation: direction)
            run(
                SKAction.sequence([SKAction.move(to: CGPoint(x: arrayToGameZonePosition(coordinate: x), y: arrayToGameZonePosition(coordinate: y)), duration: 0.2), SKAction.run {
                    level1[self.prevYPosition][self.prevXPosition] = 0
                    level1[y][x] = 3
                    self.prevXPosition = x
                    self.prevYPosition = y
                    self.move(path: pathCopy)
                }]))
        } else {
            print("wait")
            run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run({
                self.move(path: pathCopy)
            })]))
        }
        
    }
    
    func pauseGame() {
        pause = true
    }
    
    func unpauseGame() {
        pause = false
    }
}


