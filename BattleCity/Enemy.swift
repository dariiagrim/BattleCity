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
        level1[arrayY][arrayX] = 3
        self.name = "enemy"
        self.zRotation = .pi
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.enemyFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.playerFlag | Constants.bulletFlag
    }
    
    func move(path: [Point], gameZoneSize: CGSize, gameZone: GameZone) {
        guard !pause else { return }
        var pathCopy: [Point]
        if path.count == 0 {
            pathCopy = BFS(startX: arrayX, startY: arrayY)
        } else {
            pathCopy = path
        }
        if pathCopy.count > 0 {
            let move = pathCopy.removeFirst()
            let x = move.x
            let y = move.y
            let direction = move.direction
            self.zRotation = rotationToAngle(rotation: direction)
            enemyShoot(x: prevXPosition, y: prevYPosition, direction: direction, gameZoneSize: gameZoneSize, gameZone: gameZone)
            run(
                SKAction.sequence([SKAction.move(to: CGPoint(x: arrayToGameZonePosition(coordinate: x), y: arrayToGameZonePosition(coordinate: y)), duration: 0.2), SKAction.run {
                    level1[self.prevYPosition][self.prevXPosition] = 0
                    level1[y][x] = 3
                    self.prevXPosition = x
                    self.prevYPosition = y
                    self.move(path: pathCopy, gameZoneSize: gameZoneSize, gameZone: gameZone)
                }]))
        } else {
            run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run({
                self.move(path: pathCopy, gameZoneSize: gameZoneSize, gameZone: gameZone)
            })]))
        }
        
    }
    
    func randomMove() {
        var x = gameZoneToArrayPosition(coordinate: position.x)
        var y = gameZoneToArrayPosition(coordinate: position.y)
        
        let prevX = x
        let prevY = y
        
        var possibleOptions = [Rotation]()
    
        if x != 0 && level1[y][x - 1] == 0 {
            possibleOptions.append(.left)
        }
        if x != level1[0].count - 1 && level1[y][x + 1] == 0 {
            possibleOptions.append(.right)
        }
        if y != level1.count - 1 && level1[y + 1][x] == 0 {
            possibleOptions.append(.up)
        }
        if y != 0 && level1[y - 1][x] == 0 {
            possibleOptions.append(.down)
        }
        
        let direction = possibleOptions.randomElement()
        
        switch direction {
                case .down:
                    y -= 1
                    zRotation = .pi
                    rotation = .down
                case .up:
                    y += 1
                    zRotation = 0
                    rotation = .up
                case .left:
                    x -= 1
                    zRotation = .pi / 2
                    rotation = .left
                case .right:
                    x += 1
                    zRotation = .pi * 3 / 2
                    rotation = .right
                default:
                    randomMove()
                }
                
                run(SKAction.sequence([
                    SKAction.move(to: CGPoint(x: arrayToGameZonePosition(coordinate: x), y: arrayToGameZonePosition(coordinate: y)), duration: 0.3),
                    SKAction.run { [weak self] in
                        self?.randomMove()
                    }
                ]))
                level1[prevY][prevX] = 0
                level1[y][x] = 3
    }
    
    func pauseGame() {
        pause = true
    }
    
    func unpauseGame() {
        pause = false
    }
    func enemyShoot(x: Int, y: Int, direction: Rotation, gameZoneSize: CGSize, gameZone: GameZone) {
        if checkIfSomethingIsOnTheWay(x: x, y: y, direction: direction, aim: 2) {
            let bullet = Bullet(radius: 5)
            let x = arrayToGameZonePosition(coordinate: x)
            let y = arrayToGameZonePosition(coordinate: y)
            let moveAction = bullet.shoot(direction: direction, position: CGPoint(x: x, y: y), gameZoneSize: gameZoneSize)
            bullet.name = "bulletEnemy"
            gameZone.addChild(bullet)
            bullet.run(moveAction)
        }
    }
}


