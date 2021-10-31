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

class AStarPoint {
    let x: Int
    let y: Int
    let from: AStarPoint?
    let g: Int
    let h: Int
    var f: Int {
        return g + h
    }
    let direction: Rotation
    
    init(x: Int, y: Int, from: AStarPoint?, endX: Int, endY: Int, direction: Rotation) {
        self.x = x
        self.y = y
        self.from = from
        var countedG = 0
        if let fromG = from?.g {
            countedG = fromG + 1
        }
        self.g = countedG
        self.h = abs(self.x - endX) + abs(self.y - endY)
        self.direction = direction
    }
}


func AStar(start: AStarPoint, end: AStarPoint?) -> [AStarPoint]{
    if let end = end {
        var openList = [AStarPoint]()
        var closedList = [AStarPoint]()
        var visitControlArray = Array(repeating: Array(repeating: 0, count: 24), count: 20)
        openList.append(start)
        var path = [AStarPoint]()
        while !openList.isEmpty{
            openList = openList.sorted(by: { (point1, point2) -> Bool in
                point1.f > point2.f
            })
            let v = openList.removeLast()
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y, finishValue: 33)
            if finish {
                var finishX = v.x
                var finishY = v.y
                switch possibleOptions[0] {
                case .up:
                    finishY += 1
                case .down:
                    finishY -= 1
                case .right:
                    finishX += 1
                case .left:
                    finishX -= 1
                }
                let finishPoint = AStarPoint(x: finishX, y: finishY, from: v, endX: end.x, endY: end.y, direction: .up)
                path.append(finishPoint)
                var parent = finishPoint.from
                while parent != nil {
                    path.append(parent!)
                    parent = parent!.from
                }
                break
            }
            var successors = [AStarPoint]()
            
            if possibleOptions.contains(.up) {
                successors.append(AStarPoint(x: v.x, y: v.y + 1, from: v, endX: end.x, endY: end.y, direction: .up))
            }
            if possibleOptions.contains(.right) {
                successors.append(AStarPoint(x: v.x + 1, y: v.y, from: v, endX: end.x, endY: end.y, direction: .right))
            }
            if possibleOptions.contains(.left) {
                successors.append(AStarPoint(x: v.x - 1, y: v.y, from: v, endX: end.x, endY: end.y, direction: .left))
            }
            if possibleOptions.contains(.down) {
                successors.append(AStarPoint(x: v.x, y: v.y - 1, from: v, endX: end.x, endY: end.y, direction: .down))
            }
            
            for successor in successors {
                var doContinue = false
                for i in 0..<openList.count {
                    let openNode = openList[i]
                    if openNode.x == successor.x && openNode.y == successor.y {
                        if openNode.f > successor.f {
                            openList[i] = successor
                        }
                        doContinue = true
                        break
                    }
                }
                if doContinue {
                    continue
                }
                if visitControlArray[successor.y][successor.x] == 1 {
                    continue
                }
                openList.append(successor)
            }
            closedList.append(v)
            visitControlArray[v.y][v.x] = 1
        }
        
        return path
    } else {
        return [AStarPoint]()
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
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y, finishValue: 2)
            
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
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y, finishValue: 2)
            
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
            let (possibleOptions, finish) = possibleToGoOptionsFromPosition(x: v.x, y: v.y, finishValue: 2)
            
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


func possibleToGoOptionsFromPosition(x: Int, y: Int, finishValue: Int) -> ([Rotation], Bool) {
    var possibleOptions = [Rotation]()
    
    let levelSize = level1.count
    
    if x != 0 {
        let leftPositionValue = level1[y][x - 1]
        if  leftPositionValue == 0 || leftPositionValue == finishValue {
            if leftPositionValue == finishValue {
                return ([.left], true)
            }
            possibleOptions.append(.left)
        }
    }
    
    if x != level1[0].count - 1 {
        let rightPositionValue = level1[y][x + 1]
        if rightPositionValue == 0 || rightPositionValue == finishValue {
            if rightPositionValue == finishValue {
                return ([.right], true)
            }
            possibleOptions.append(.right)
        }
    }
    
    if y != 0 {
        let downPositionValue = level1[y - 1][x]
        if  downPositionValue == 0 || downPositionValue == finishValue {
            if downPositionValue == finishValue {
                return ([.down], true)
            }
            possibleOptions.append(.down)
        }
    }
    
    if y != level1.count - 1 {
        let upPositionValue = level1[y + 1][x]
        if upPositionValue == 0 || upPositionValue == finishValue {
            if upPositionValue == finishValue {
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
