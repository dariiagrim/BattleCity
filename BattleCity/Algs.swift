//
//  Algs.swift
//  BattleCity
//
//  Created by Dariia Hrymalska on 14.09.2021.
//

import Foundation
import SpriteKit

class Point {
    let x: Int
    let y: Int
    let from: Point?
    
    init(x: Int, y: Int, from: Point?) {
        self.x = x
        self.y = y
        self.from = from
    }
}

class PointWithPriority {
    let x: Int
    let y: Int
    let from: PointWithPriority?
    let distance: Int
    
    init(x: Int, y: Int, from: PointWithPriority?, distance: Int) {
        self.x = x
        self.y = y
        self.from = from
        self.distance = distance
    }
}

func DFS(startX: Int, startY: Int, gameZone: GameZone) {
    var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
    var stack = [Point]()
    
    stack.append(Point(x: startX, y: startY, from: nil))
    var finishPoint: Point? = nil
    
    while !stack.isEmpty {
        let v = stack.removeLast()
        if visitControlArray[level1.count - v.y - 1][v.x] == 0 {
            visitControlArray[level1.count - v.y - 1][v.x] = 1
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y)
            
            if possibleOptions.contains(.up) {
                stack.append(Point(x: v.x, y: v.y + 1, from: v))
            }
            if possibleOptions.contains(.right) {
                stack.append(Point(x: v.x + 1, y: v.y, from: v))
            }
            if possibleOptions.contains(.left) {
                stack.append(Point(x: v.x - 1, y: v.y, from: v))
            }
            if possibleOptions.contains(.down) {
                stack.append(Point(x: v.x, y: v.y - 1, from: v))
            }
            if finish {
                finishPoint = stack.removeLast()
                break
            }
        }
    }
    

    var pathCounter = 0
    if finishPoint != nil {
        var point = finishPoint
        while point != nil {
            let pathMarker = SKShapeNode(rectOf: CGSize(width: 18, height: 18))
            pathMarker.position = CGPoint(x: arrayToGameZonePosition(coordinate: point!.x), y: arrayToGameZonePosition(coordinate: point!.y))
            pathMarker.fillColor = .red
            gameZone.addChild(pathMarker)
            point = point!.from
            pathCounter += 1
        }
    }
    print(pathCounter)
    
}

func BFS(startX: Int, startY: Int, gameZone: GameZone) {
    var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
    var stack = [Point]()
    
    stack.append(Point(x: startX, y: startY, from: nil))
    var finishPoint: Point? = nil
    
    while !stack.isEmpty {
        let v = stack.removeFirst()
        if visitControlArray[level1.count - v.y - 1][v.x] == 0 {
            visitControlArray[level1.count - v.y - 1][v.x] = 1
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y)
            
            if possibleOptions.contains(.up) {
                stack.append(Point(x: v.x, y: v.y + 1, from: v))
            }
            if possibleOptions.contains(.right) {
                stack.append(Point(x: v.x + 1, y: v.y, from: v))
            }
            if possibleOptions.contains(.left) {
                stack.append(Point(x: v.x - 1, y: v.y, from: v))
            }
            if possibleOptions.contains(.down) {
                stack.append(Point(x: v.x, y: v.y - 1, from: v))
            }
            if finish {
                finishPoint = stack.removeLast()
                break
            }
        }
    }
    
    
    var pathCounter = 0
    
    if finishPoint != nil {
        var point = finishPoint
        while point != nil {
            let pathMarker = SKShapeNode(rectOf: CGSize(width: 12, height: 12))
            pathMarker.position = CGPoint(x: arrayToGameZonePosition(coordinate: point!.x), y: arrayToGameZonePosition(coordinate: point!.y))
            pathMarker.fillColor = .blue
            pathMarker.name = "pathMarker"
            gameZone.addChild(pathMarker)
            point = point!.from
            pathCounter += 1
        }
    }
    
    print(pathCounter)
    
}

func UCS(startX: Int, startY: Int, gameZone: GameZone) {
    var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
    var stack = [PointWithPriority]()
    
    var distanceCounter = 0
    stack.append(PointWithPriority(x: startX, y: startY, from: nil, distance: distanceCounter))
    var finishPoint: PointWithPriority? = nil
    
    distanceCounter += 1
    
    while !stack.isEmpty {
        stack = stack.sorted(by: { (point1, point2) -> Bool in
            point1.distance > point2.distance
        })
        let v = stack.removeLast()
        if visitControlArray[level1.count - v.y - 1][v.x] == 0 {
            visitControlArray[level1.count - v.y - 1][v.x] = 1
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y)
            
            if possibleOptions.contains(.up) {
                stack.append(PointWithPriority(x: v.x, y: v.y + 1, from: v, distance: distanceCounter))
            }
            if possibleOptions.contains(.right) {
                stack.append(PointWithPriority(x: v.x + 1, y: v.y, from: v, distance: distanceCounter))
            }
            if possibleOptions.contains(.left) {
                stack.append(PointWithPriority(x: v.x - 1, y: v.y, from: v,distance: distanceCounter))
            }
            if possibleOptions.contains(.down) {
                stack.append(PointWithPriority(x: v.x, y: v.y - 1, from: v, distance: distanceCounter))
            }
            if finish {
                finishPoint = stack.removeLast()
                break
            }
            distanceCounter += 1
        }
    }
    
    

    var pathCounter = 0
    if finishPoint != nil {
        var point = finishPoint
        while point != nil {
            let pathMarker = SKShapeNode(rectOf: CGSize(width: 8, height: 8))
            pathMarker.position = CGPoint(x: arrayToGameZonePosition(coordinate: point!.x), y: arrayToGameZonePosition(coordinate: point!.y))
            pathMarker.fillColor = .green
            pathMarker.name = "pathMarker"
            gameZone.addChild(pathMarker)
            point = point!.from
            pathCounter += 1
        }
    }
    print(pathCounter)
    
}


func possibleToGoOptionsFromPosition(x: Int, y: Int) -> ([Rotation], Bool) {
    var possibleOptions = [Rotation]()
    
    let levelSize = level1.count
    
    if x != 0 {
        let leftPositionValue = level1[levelSize - y - 1][x - 1]
        if  leftPositionValue == 0 || leftPositionValue == 2 {
            if leftPositionValue == 2 {
                return ([.left], true)
            }
            possibleOptions.append(.left)
        }
    }
    
    if x != level1[0].count - 1 {
        let rightPositionValue = level1[levelSize - y - 1][x + 1]
        if rightPositionValue == 0 || rightPositionValue == 2 {
            if rightPositionValue == 2 {
                return ([.right], true)
            }
            possibleOptions.append(.right)
        }
    }
    
    if y != 0 {
        let downPositionValue = level1[levelSize - y][x]
        if  downPositionValue == 0 || downPositionValue == 2 {
            if downPositionValue == 2 {
                return ([.down], true)
            }
            possibleOptions.append(.down)
        }
    }
    
    if y != level1.count - 1 {
        let upPositionValue = level1[levelSize - y - 2][x]
        if upPositionValue == 0 || upPositionValue == 2 {
            if upPositionValue == 2 {
                return ([.up], true)
            }
            possibleOptions.append(.up)
        }
    }
    
    return (possibleOptions, false)
}

enum AlgEnum  {
    case dfs, bfs, ucs
}
